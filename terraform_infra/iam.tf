# Create the Airflow User
resource "aws_iam_user" "airflow_user" {
  name = var.iam_user
}

# Keys for the user
resource "aws_iam_access_key" "airflow_user_keys" {
  user = aws_iam_user.airflow_user.name
}

# Permissions
resource "aws_iam_policy" "migration_policy" {
  name = "S3MigrationPolicy"
  description = "Allows the Airflow user to read from the source s3 to the data lake"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permission to write to bronze layer S3 - data lake
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:ListBucket", "s3:GetBucketLocation"]
        Resource = [
          "${aws_s3_bucket.centralized_data_lake.arn}",
          "${aws_s3_bucket.centralized_data_lake.arn}/*"
]
      }
    ]
  })
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.airflow_user.name
  policy_arn = aws_iam_policy.migration_policy.arn
}


# Snowflake IAM role
resource "aws_iam_role" "snowflake_role" {
  name = "snowflake_s3_reader"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.snowflake_storage_user_arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.snowflake_external_id
          }
        }
      }
    ]
  })
}


# Permission policy of Snowflake's IAM role
resource "aws_iam_policy" "snowflake_s3_access" {
  name        = "SnowflakeS3Access"
  description = "Allows Snowflake to list and read files from the S3 warehouse bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.centralized_bucket_name}",
          "arn:aws:s3:::${var.centralized_bucket_name}/*"
        ]
      }
    ]
  })
}

# Linking the Permissions to the Role
resource "aws_iam_role_policy_attachment" "snowflake_attach" {
  role = aws_iam_role.snowflake_role.name
  policy_arn = aws_iam_policy.snowflake_s3_access.arn
}