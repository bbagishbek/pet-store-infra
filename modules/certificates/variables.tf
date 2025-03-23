variable "domain_names" {
  description = "The main domain for the SSL certificate"
  type        = list(string)
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  type = string
}
