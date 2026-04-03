from airflow.providers.amazon.aws.hooks.base_aws import AwsBaseHook
from pathlib import Path

def profile_setup():
    # Connect to AWS
    aws_hook = AwsBaseHook(aws_conn_id='dest_conn', client_type='ssm', region_name='us-east-2')
    ssm = aws_hook.get_conn()
    
    # Helper to fetch secrets
    def get_val(name):
        return ssm.get_parameter(Name=name, WithDecryption=True)["Parameter"]["Value"]

    # Build the dbt Profile
    profile_content = f"""
supplychain360_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: {get_val("/supplychain/snowflake/account")}
      user: {get_val("/supplychain/snowflake/username")}
      password: {get_val("/supplychain/snowflake/password")}
      role: ACCOUNTADMIN
      warehouse: COMPUTE_WH
      database: SUPPLYCHAIN360_DB
      schema: SILVER
      threads: 4
"""

    # Save/Overwrite the file
    target_path = Path("/opt/airflow/dags/dbt_transform/profiles.yml")
    target_path.parent.mkdir(parents=True, exist_ok=True)
    target_path.write_text(profile_content.strip())
    
    print("Profile successfuly generated.")