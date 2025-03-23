resource "aws_ecs_service" "web" {
  name            = "${var.app_name}-web-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = var.ui_desired_count
  launch_type     = "EC2"

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.web_tg_arn
    container_name   = "${var.app_name}-web-container"
    container_port   = 80
  }

  tags = {
    Environment = var.environment
    Service     = "web"
  }
}

resource "aws_ecs_service" "api" {
  name            = "${var.app_name}-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.api_desired_count
  launch_type     = "EC2"

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.api_tg_arn
    container_name   = "${var.app_name}-api-container"
    container_port   = 80
  }

  tags = {
    Environment = var.environment
    Service     = "api"
  }
}
