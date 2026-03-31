# This is the security object that allows Snowflake to assume an AWS IAM Role
resource "snowflake_storage_integration" "s3_integration" {
  name = "S3_DESTINATION_INT"
  comment = "Connection to the S3 destination bucket for Airflow loads"
  type = "EXTERNAL_STAGE"

  enabled = true

  storage_allowed_locations = ["s3://${var.centralized_bucket_name}/"]
  storage_provider = "S3"
  
  # IAM Role in AWS
  storage_aws_role_arn = aws_iam_role.snowflake_role.arn
}

# The compute (warehouse)
resource "snowflake_warehouse" "supplychain_wh" {
  name = "SUPPLYCHAIN_COMPUTE_WH"
  warehouse_size = "X-SMALL"
  auto_suspend = 60
  auto_resume = true
}

# The database
resource "snowflake_database" "supplychain360_db" {
  name    = "SUPPLYCHAIN360_DB"
  comment = "Main warehouse for Supplychain360 data platform"
}

# The Bronze schema
resource "snowflake_schema" "bronze" {
  name     = "BRONZE"
  database = snowflake_database.supplychain360_db.name
  comment  = "Raw ingested data from S3 bucket"
}

# The Silver schema
resource "snowflake_schema" "silver" {
  name     = "SILVER"
  database = snowflake_database.supplychain360_db.name
  comment  = "Cleaned and filtered records"
}

# The Gold schema
resource "snowflake_schema" "gold" {
  name     = "GOLD"
  database = snowflake_database.supplychain360_db.name
  comment  = "Final tables for analysis"
}

# Read the parquet files
resource "snowflake_file_format" "parquet_format" {
  name        = "PARQUET_FORMAT"
  database    = snowflake_database.supplychain360_db.name
  schema      = snowflake_schema.bronze.name
  format_type = "PARQUET"
  compression = "SNAPPY"
  comment     = "Standard format for reading Snappy-compressed Parquet files."
}

# Loops through the s3 folders and creates a secure 'Stage' for every folder listed in [var.supply_chain_folders]
resource "snowflake_stage" "s3_stages" {
  for_each = toset(var.s3_folders)

  name     = "${upper(each.key)}_STAGE"
  url      = "s3://${var.centralized_bucket_name}/${each.key}/"
  database = snowflake_database.supplychain360_db.name
  schema   = snowflake_schema.bronze.name
  
  # Uses the IAM Role handshake configured in the Storage Integration
  storage_integration = snowflake_storage_integration.s3_integration.name
  
  # Links the stage to the Parquet format by default
  file_format = "TYPE = 'PARQUET', COMPRESSION = 'SNAPPY'"
  
  depends_on = [
    snowflake_database.supplychain360_db,
    snowflake_schema.bronze,
    snowflake_file_format.parquet_format
  ]
}