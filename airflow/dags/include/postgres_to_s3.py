from airflow.sdk import Variable
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from datetime import datetime
import pandas as pd
import io

def postgres_extract():
    db_hook = PostgresHook(postgres_conn_id='postgres_conn')
    s3_hook = S3Hook(aws_conn_id='dest_conn')
    bucket_name = Variable.get("dest_bucket")
    
    # Get the list of tables with "public" schema
    table_query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
    table_list = db_hook.get_pandas_df(sql=table_query)['table_name'].values.tolist()

    for table in table_list:
        # We define exactly what the final file should be named
        file_key = f"store_sales/{table}.parquet"
        
        # Check if this exact file already exists in the bucket
        if s3_hook.check_for_key(key=file_key, bucket_name=bucket_name):
            print(f"{file_key} exists already.")
            continue 

        # If file is missing, pull the data
        print(f"Ingesting {table}")
        df = db_hook.get_pandas_df(sql=f"SELECT * FROM {table}")

        # Convert everything to string to handle UUIDs/Special Types
        df = df.astype(str)
        
        # Add the 'ingested_at' column
        df['ingested_at'] = datetime.now()

        # Convert to Parquet in memory
        buffer = io.BytesIO()
        df.to_parquet(buffer, index=False)
        buffer.seek(0)

        # Upload file
        s3_hook.load_file_obj(
            file_obj=buffer,
            key=file_key,
            bucket_name=bucket_name,
            replace=False    #don't overwrite
        )
        print(f"Successfully saved {table} to {file_key}")