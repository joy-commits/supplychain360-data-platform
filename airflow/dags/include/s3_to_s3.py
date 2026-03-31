from airflow.sdk import Variable
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from datetime import datetime
import pandas as pd
import io
import os

def s3_to_s3_extract():
    # Define connections and configs
    source_hook = S3Hook(aws_conn_id='source_conn')
    dest_hook = S3Hook(aws_conn_id='dest_conn')
    source_bucket = Variable.get("source_bucket")
    dest_bucket = Variable.get("dest_bucket")
    prefix = Variable.get("prefix")

    # List files in the source bucket
    keys = source_hook.list_keys(bucket_name=source_bucket, prefix=prefix)
    
    if not keys:
        print("No files found to process.")
        return

    for source_key in keys:
        # Skip folders or non-data files
        if source_key.endswith('/') or not (source_key.endswith('.csv') or source_key.endswith('.json')):
            continue

        # Define destination Key (Convert .csv/.json to .parquet)
        file_key = source_key.replace(prefix, "")
        base_name = os.path.splitext(file_key)[0]
        dest_key = f"{base_name}.parquet"

        # Skip if already in the destination s3
        if dest_hook.check_for_key(key=dest_key, bucket_name=dest_bucket):
            print(f"{dest_key} already exists.")
            continue

        print(f"Processing {source_key} -> {dest_key}")

        # Download & convert
        file_obj = source_hook.get_conn().get_object(Bucket=source_bucket, Key=source_key)
        data = file_obj['Body'].read()

        if source_key.endswith('.csv'):
            df = pd.read_csv(io.BytesIO(data))
        else:
            df = pd.read_json(io.BytesIO(data))

        # Handle UUIDs and object types (to prevent ArrowInvalid errors)
        df = df.astype(str) 
        
        # Add metadata column
        df['ingested_at'] = datetime.now().isoformat()

        # Upload as parquet
        buffer = io.BytesIO()
        df.to_parquet(buffer, index=False)
        buffer.seek(0)

        dest_hook.load_file_obj(
            file_obj=buffer,
            key=dest_key,
            bucket_name=dest_bucket,
            replace=True
        )
        print(f"{source_key} moved successfully to data lake")