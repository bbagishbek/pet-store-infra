resource "aws_lb" "pet_store_alb" {
  name               = "pet-store-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pet_store_alb_sg.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "pet_store_ui_tg" {
  name        = "pet-store-ui-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "pet_store_ui_tg"
  }
}

resource "aws_lb_target_group" "pet_store_api_tg" {
  name        = "pet-store-api-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/api/health"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.pet_store_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pet_store_ui_tg.arn
  }
}

resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pet_store_api_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api*"]
    }
  }

  tags = {
    Name = "api"
  }
}

data "aws_route53_zone" "petstore" {
  name         = "bagishbek.com" # Replace with your domain
  private_zone = false
}

# Route 53 Record for the API
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.petstore.zone_id
  name    = "petstore.bagishbek.com" # Subdomain for API
  type    = "A"

  alias {
    name                   = aws_lb.pet_store_alb.dns_name
    zone_id                = aws_lb.pet_store_alb.zone_id
    evaluate_target_health = true
  }
}
