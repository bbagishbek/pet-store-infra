output "certificate_arn" {
  description = "ARN of the ACM Certificate"
  value       = aws_acm_certificate.main.arn
}
