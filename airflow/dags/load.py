from airflow.sdk import DAG, Variable
#from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator as SnowflakeOperator
from datetime import datetime, timedelta

S3_FOLDERS = Variable.get("s3_folders", deserialize_json=True)

# DAG Definition

with DAG(
    's3_to_snowflake_load',
    default_args={
        'owner': 'Ufuoma',
        'retries': 3,
        'retry_delay': timedelta(minutes=5),
        },
    description='Orchestrate .parquet file ingestion from s3 to Snowflake Bronze Layer',
    schedule=None, 
    start_date=datetime(2026, 3, 30),
    catchup=False,
    max_active_runs=1,
    template_searchpath=['/opt/airflow/dags/include/']
) as dag:

    # Loop through folders to create dynamic tasks
    for folder in S3_FOLDERS:
        table_name = folder.upper()
        stage_name = f"{table_name}_STAGE"

        load_task = SnowflakeOperator(
            task_id=f'ingest_{folder}',
            conn_id='snowflake_conn',
            sql='s3_to_snowflake.sql',
            params={
                'database': 'SUPPLYCHAIN360_DB',
                'schema': 'BRONZE',
                'table': table_name,
                'stage': stage_name
            }
        )

        load_task