variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}
variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets where the ALB will be deployed"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed to access HTTP (80)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed to access HTTPS (443)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to access SSH (22)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change to your IP for better security
}
