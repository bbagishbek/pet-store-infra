variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet for the Bastion host"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to access the Bastion via SSH"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the Bastion Host"
  type        = string
}
