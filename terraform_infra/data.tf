# Fetching the postgres DB parameters

provider "aws" {
    alias = "source"
    region  = "eu-west-2"
    profile = var.source_aws_profile
}

data "aws_ssm_parameter" "db_user" {
    provider = aws.source
    name = "/supplychain360/db/user"
}

data "aws_ssm_parameter" "db_pass" {
    provider = aws.source
    name = "/supplychain360/db/password"
    with_decryption = true
}

data "aws_ssm_parameter" "db_host" {
    provider = aws.source
    name = "/supplychain360/db/host"
}

data "aws_ssm_parameter" "db_port" {
    provider = aws.source
    name = "/supplychain360/db/port"
}

data "aws_ssm_parameter" "db_name" {
    provider = aws.source
    name = "/supplychain360/db/dbname"
}