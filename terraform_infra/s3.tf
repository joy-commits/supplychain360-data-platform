# The configurations for the data lake

resource "aws_s3_bucket" "centralized_data_lake" {
  bucket = var.centralized_bucket_name
  tags = {
    Name = "SupplyChain360 Bronze Data Lake"
    Environment = "Dev"
  }
}

# Enable bucket versioning for the centralized data lake
resource "aws_s3_bucket_versioning" "data_lake_versioning" {
  bucket = aws_s3_bucket.centralized_data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.centralized_data_lake.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


# Configurations for the terraform statefile s3 bucket
resource "aws_s3_bucket" "statefile_bucket" {
  bucket = "supplychain360-terraform-statefile"
  tags = {
    Name = "SupplyChain360 Terraform Statefile bucket"
    Environment = "Dev"
  }
}

# Enable bucket versioning for the statefile bucket
resource "aws_s3_bucket_versioning" "statefile_versioning" {
  bucket = aws_s3_bucket.statefile_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}