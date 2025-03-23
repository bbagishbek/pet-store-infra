variable "app_name" {
  description = "The name of the application (used for naming ECS resources)"
  type        = string
}

variable "web_repository_url" {
  description = "ECR repository URL for the Web (UI) service container image"
  type        = string
}

variable "api_repository_url" {
  description = "ECR repository URL for the API service container image"
  type        = string
}

variable "task_cpu" {
  description = "Amount of CPU units to allocate for ECS tasks"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Amount of memory (in MiB) to allocate for ECS tasks"
  type        = number
  default     = 512
}

variable "ui_desired_count" {
  description = "Number of desired ECS service tasks for the Web (UI) service"
  type        = number
  default     = 1
}

variable "api_desired_count" {
  description = "Number of desired ECS service tasks for the API service"
  type        = number
  default     = 1
}

variable "web_tg_arn" {
  description = "ARN of the ALB Target Group used by the Web (UI) service"
  type        = string
}

variable "api_tg_arn" {
  description = "ARN of the ALB Target Group used by the API service"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the infrastructure is deployed"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where ECS and networking resources are deployed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to use for ECS container instances"
  type        = string
  default     = "t3.micro"
}

variable "public_subnets" {
  description = "List of public subnet IDs (e.g., for ALB or public ECS instances)"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group that allows inbound traffic to ECS services"
  type        = string
}

variable "db_password_arn" {
  description = "ARN of the SSM parameter storing the database password"
  type        = string
}

variable "db_host_arn" {
  description = "ARN of the SSM parameter storing the database host"
  type        = string
}

variable "db_user_arn" {
  description = "ARN of the SSM parameter storing the database username"
  type        = string
}

variable "db_port_arn" {
  description = "ARN of the SSM parameter storing the database port"
  type        = string
}

variable "db_name_arn" {
  description = "ARN of the SSM parameter storing the database name"
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)"
  type        = string
}
