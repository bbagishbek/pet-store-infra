variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "ecs_task_sg_id" {
  description = "ID of the ALB security group"
}
