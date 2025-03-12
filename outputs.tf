output "alb_dns" {
  value = aws_lb.pet_store_alb.dns_name
}

output "ecr_ui_repo" {
  value = aws_ecr_repository.pet_store_ui.repository_url
}

output "ecr_api_repo" {
  value = aws_ecr_repository.pet_store_api.repository_url
}
