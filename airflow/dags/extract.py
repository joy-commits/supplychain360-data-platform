from airflow.sdk import DAG
from pendulum import datetime, duration
from airflow.providers.standard.operators.python import PythonOperator
from include.postgres_to_s3 import postgres_extract
from include.s3_to_s3 import s3_to_s3_extract
from include.google_sheets_to_s3 import google_sheets_extract

# DAG Definition

with DAG(
    dag_id="extract_to_s3",
    start_date=datetime(2026, 3, 20),
    schedule=None,
    catchup=False,
    default_args={
        "owner": "Ufuoma",
        "retries": 5,
        "retry_delay": duration(seconds=40)
    }
):

    extract_from_sheets = PythonOperator(
        task_id='google_sheets',
        python_callable=google_sheets_extract
    )

    extract_from_s3 = PythonOperator(
        task_id='source_s3',
        python_callable=s3_to_s3_extract
    )

    extract_from_postgres = PythonOperator(
        task_id='postgres',
        python_callable=postgres_extract
    )

    extract_from_sheets >> extract_from_s3 >> extract_from_postgres