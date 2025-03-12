variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1" # Optional default value
}

variable "ecr_ui_repo_name" {
  description = "ECR repository name for UI"
  type        = string
}

variable "ecr_api_repo_name" {
  description = "ECR repository name for API"
  type        = string
}
