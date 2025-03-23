output "db_password_arn" {
  description = "ARN of the DB password parameter"
  value       = aws_ssm_parameter.db_password.arn
}

output "db_host_arn" {
  description = "ARN of the DB host parameter"
  value       = aws_ssm_parameter.db_host.arn
}

output "db_user_arn" {
  description = "ARN of the DB user parameter"
  value       = aws_ssm_parameter.db_user.arn
}

output "db_port_arn" {
  description = "ARN of the DB port parameter"
  value       = aws_ssm_parameter.db_port.arn
}

output "db_name_arn" {
  description = "ARN of the DB name parameter"
  value       = aws_ssm_parameter.db_name.arn
}
