# Store statefile remotely in an s3 bucket
terraform {
  backend "s3" {
    bucket = "supplychain360-terraform-statefile"
    key = "dev/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    use_lockfile = true  # prevents 2 people from running terraform at once
  }
}