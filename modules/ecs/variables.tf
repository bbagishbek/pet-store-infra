variable "app_name" {
  description = "The name of the Application"
  type        = string
}

variable "web_repository_url" {
  description = "ECR repository URL for the UI service"
  type        = string
}

variable "api_repository_url" {
  description = "ECR repository URL for the API service"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for ECS tasks"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for ECS tasks"
  type        = number
  default     = 512
}

variable "ui_desired_count" {
  description = "Desired number of UI service instances"
  type        = number
  default     = 1
}

variable "api_desired_count" {
  description = "Desired number of API service instances"
  type        = number
  default     = 1
}

variable "web_tg_arn" {
  description = "Target Group ARN for the UI service"
  type        = string
}

variable "api_tg_arn" {
  description = "Target Group ARN for the API service"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_subnets" {
  description = "List of public subnets where the ALB will be deployed"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "db_password_arn" {
  type = string
}
variable "db_host_arn" {
  type = string
}
variable "db_user_arn" {
  type = string
}
variable "db_port_arn" {
  type = string
}

variable "db_name_arn" {
  type = string
}
variable "environment" {
  type = string
}
