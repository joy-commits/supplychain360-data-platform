terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    snowflake = {
      source = "snowflakedb/snowflake"
      version = "~> 0.87.0"  #latest stable version
    }
 }
}


# Configure the AWS and Snowflake providers

provider "aws" {
  region = "${var.aws_region}"
  default_tags {
    tags = {
      Environment = "dev"
      Owner = "Ufuoma E"
      Project = "Supplychain360 data platform"
    }
  }
  profile = "supplychain-dev"
}


provider "snowflake" {
  account  = "${var.snowflake_organization}-${var.snowflake_account}"
  user = var.snowflake_username
  password = var.snowflake_password
  role     = "ACCOUNTADMIN"
}