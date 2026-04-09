from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from datetime import datetime

with DAG(
    dag_id="extract_load_transform_pipeline",
    start_date=datetime(2026, 3, 30),
    schedule='@daily',
    catchup=False,
    max_active_runs=1
) as dag:

    # Trigger the extraction from source to s3 (the data lake)
    trigger_extract = TriggerDagRunOperator(
        task_id='trigger_extract_to_s3',
        trigger_dag_id='extract_to_s3',
        wait_for_completion=True,
        poke_interval=60
    )

    # Trigger loading from s3 to Snowflake (the data warehouse)
    trigger_load = TriggerDagRunOperator(
        task_id='trigger_s3_to_snowflake',
        trigger_dag_id='s3_to_snowflake_load',
        wait_for_completion=True
    )

    # Trigger transformation with dbt
    trigger_transform = TriggerDagRunOperator(
        task_id='trigger_dbt_transform',
        trigger_dag_id='dbt_transform',
        wait_for_completion=True
    )

    # The Flow
    trigger_extract >> trigger_load >> trigger_transform
