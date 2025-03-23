resource "aws_ecr_repository" "web" {
  name                 = "${var.app_name}-ui"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-ui"
    Environment = var.environment
    Service     = "web"
  }

  # Uncomment if you want to prevent accidental deletion
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ecr_repository" "api" {
  name                 = "${var.app_name}-api"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-api"
    Environment = var.environment
    Service     = "api"
  }

  # Uncomment if you want to prevent accidental deletion
  # lifecycle {
  #   prevent_destroy = true
  # }
}
