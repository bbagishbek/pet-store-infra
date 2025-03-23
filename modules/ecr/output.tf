output "web_repository_url" {
  description = "URL of the ECR repository for the UI service"
  value       = aws_ecr_repository.web.repository_url
}

output "api_repository_url" {
  description = "URL of the ECR repository for the API service"
  value       = aws_ecr_repository.api.repository_url
}
