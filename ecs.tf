resource "aws_ecs_cluster" "pet_store_cluster" {
  name = "pet-store-cluster"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "pet_store_ui_task" {
  family                   = "pet-store-ui-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "pet-store-ui"
      image     = "${aws_ecr_repository.pet_store_ui.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_task_definition" "pet_store_api_task" {
  family                   = "pet-store-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "pet-store-api"
      image     = "${aws_ecr_repository.pet_store_api.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/pet-store-api"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
resource "aws_cloudwatch_log_group" "pet_store_api" {
  name = "/ecs/pet-store-api"
}
resource "aws_ecs_service" "pet_store_ui_service" {
  name            = "pet-store-ui-service"
  cluster         = aws_ecs_cluster.pet_store_cluster.id
  task_definition = aws_ecs_task_definition.pet_store_ui_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.pet_store_alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pet_store_ui_tg.arn
    container_name   = "pet-store-ui"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}

resource "aws_ecs_service" "pet_store_api_service" {
  name            = "pet-store-api-service"
  cluster         = aws_ecs_cluster.pet_store_cluster.id
  task_definition = aws_ecs_task_definition.pet_store_api_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.pet_store_alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pet_store_api_tg.arn
    container_name   = "pet-store-api"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}
