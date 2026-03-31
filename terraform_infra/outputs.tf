output "database_details" {
  value = {
    host = data.aws_ssm_parameter.db_host.value
    password = data.aws_ssm_parameter.db_pass.value
    user = data.aws_ssm_parameter.db_user.value
    port = data.aws_ssm_parameter.db_port.value
    name = data.aws_ssm_parameter.db_name.value
  }
  sensitive = true
}

output "snowflake_handshake_command" {
  value = "Run this in Snowflake: DESCRIBE STORAGE INTEGRATION ${snowflake_storage_integration.s3_integration.name};"
  description = "The command to get the ARNs needed to secure your AWS Role"
}