from airflow.sdk import Variable
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from airflow.providers.google.common.hooks.base_google import GoogleBaseHook
from datetime import datetime
from google.oauth2 import service_account
import pandas as pd
import gspread
import io
import json


def google_sheets_extract():
    # Setup configurations
    s3_hook = S3Hook(aws_conn_id='dest_bucket')
    sheet_name = Variable.get("sheet_name")
    dest_bucket = Variable.get("dest_bucket")
    dest_key = "store_locations/stores.parquet"

    with open("supplychain360-490812-1c1ba1e509e8.json") as f:
        keyfile_dict = json.load(f)

    creds = service_account.Credentials.from_service_account_info(
        keyfile_dict,
        scopes=[
            "https://www.googleapis.com/auth/spreadsheets",
            "https://www.googleapis.com/auth/drive"
        ]
    )

    gc = gspread.authorize(creds)
    
    # Fetch Data from Google Sheets
    print(f"Accessing {sheet_name}")
    sh = gc.open(sheet_name)
    worksheet = sh.sheet1
    new_df = pd.DataFrame(worksheet.get_all_records())
    
    # lowercase columns and replace spaces
    new_df.columns = [col.lower().replace(' ', '_') for col in new_df.columns]

    # Incremental
    try:
        # Check if file exists in S3
        if s3_hook.check_for_key(dest_key, bucket_name=dest_bucket):
            file_obj = s3_hook.get_conn().get_object(Bucket=dest_bucket, Key=dest_key)
            existing_df = pd.read_parquet(io.BytesIO(file_obj['Body'].read()))
            
            # Find rows where store_id is NOT in the existing S3 file
            incremental_df = new_df[~new_df['store_id'].isin(existing_df['store_id'])].copy()
            
            if incremental_df.empty:
                print("No new stores found in source")
                return
            
            print(f"{len(incremental_df)} new store locations found")
            
            incremental_df['ingested_at'] = datetime.now().isoformat()
            # Combine old data + new data
            final_df = pd.concat([existing_df, incremental_df], ignore_index=True)
        else:
            raise Exception("File not found") # Trigger the 'first run' logic

    except Exception:   # if the file doesn't exist in the destination s3 bucket
        print("Creating fresh parquet file")
        final_df = new_df.copy()
        final_df['ingested_at'] = datetime.now().isoformat()

    # Handle UUID/object types (Best practice to prevent Arrow errors)
    final_df = final_df.astype(str)

    # Upload to S3
    buffer = io.BytesIO()
    final_df.to_parquet(buffer, index=False)
    buffer.seek(0)

    s3_hook.load_file_obj(
        file_obj=buffer,
        key=dest_key,
        bucket_name=dest_bucket,
        replace=True
    )
    print(f"{dest_key} updated successfully")