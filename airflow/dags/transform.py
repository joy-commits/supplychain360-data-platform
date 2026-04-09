from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import PythonOperator
from datetime import datetime, timedelta
from dbt_transform.generate_dbt_profile import profile_setup

DBT_DIR = "/opt/airflow/dags/dbt_transform"
DBT_PROFILES_DIR = "/opt/airflow/dags/dbt_transform"
EXEC = "/home/airflow/.local/bin/dbt"

# DAG definition
with DAG(
    dag_id="dbt_transform",
    description='Transform data in Snowflake Bronze Layer using dbt',
    schedule=None, 
    start_date=datetime(2026, 3, 31),
    catchup=False,
    max_active_runs=1,
    template_searchpath=['/opt/airflow/dags/dbt_transform/'],
    default_args={
        'owner': 'Ufuoma',
        'retries': 3,
        'retry_delay': timedelta(minutes=5),
        }
) as dag:

    dbt_profile = PythonOperator(
        task_id='setup_dbt_profile',
        python_callable=profile_setup
    )

    # Run silver/staging models
    dbt_run_staging = BashOperator(
        task_id="dbt_run_staging",
        bash_command=f"cd {DBT_DIR} && {EXEC} run --select staging --profiles-dir {DBT_PROFILES_DIR}",
    )

    # Run gold/marts models
    dbt_run_marts = BashOperator(
        task_id="dbt_run_marts",
        bash_command=f"cd {DBT_DIR} && {EXEC} run --select marts --profiles-dir {DBT_PROFILES_DIR}",
    )

    # Test all models
    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_DIR} && {EXEC} test --profiles-dir {DBT_PROFILES_DIR}",
    )

    dbt_profile >> dbt_run_staging >> dbt_run_marts >> dbt_test
