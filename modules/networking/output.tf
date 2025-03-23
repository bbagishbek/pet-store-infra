output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The ALB hosted zone ID"
  value       = aws_lb.main.zone_id
}

output "ui_target_group_arn" {
  description = "Target Group ARN for the UI service"
  value       = aws_lb_target_group.web_tg.arn
}

output "api_target_group_arn" {
  description = "Target Group ARN for the API service"
  value       = aws_lb_target_group.api_tg.arn
}

output "alb_security_group_id" {
  description = "Security Group ID of the Bastion instance"
  value       = aws_security_group.alb_sg.id
}
