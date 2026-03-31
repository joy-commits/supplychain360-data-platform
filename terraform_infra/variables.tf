variable "external_bucket_name" {
    description = "The name of the source bucket"
    type = string
}

variable "centralized_bucket_name" {
    description = "The name of the new destination bucket"
    type = string
}

variable "aws_region" {
    type = string
}

variable "iam_user" {
    type = string
    default = "s3-airflow-user"
}

variable "statefile_bucket" {
    type = string
    default = "supplychain360-terraform-statefile"
}

variable "source_aws_profile" {
    type = string
    description = "The name of the AWS CLI profile for the source"
}

variable "snowflake_organization" {
    type = string
}

variable "snowflake_account" {
    type = string
}

variable "snowflake_username" {
    type = string
}

variable "snowflake_password" {
    type = string
    sensitive = true
}

variable "aws_account_id" {
    type = string
    description = "The account ID of the data lake"
    sensitive = true
}

variable "snowflake_storage_user_arn" {
  type        = string
  description = "The STORAGE_AWS_IAM_USER_ARN from Snowflake DESCRIBE"
}

variable "snowflake_external_id" {
  type        = string
  description = "The STORAGE_AWS_EXTERNAL_ID from Snowflake DESCRIBE"
}

variable "s3_folders" {
  type        = list(string)
  description = "List of S3 folders"
  default     = ["inventory", "products", "shipments", "store_locations", "store_sales", "suppliers", "warehouses"]
}