# Fetch AWS account ID dynamically
data "aws_caller_identity" "current" {}
# -------------------------------
# ECS EXECUTION ROLE custom
# -------------------------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.app_name}-${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment
    Role        = "ecs-execution"
  }
}

# Attach the base Amazon-managed ECS execution policy
resource "aws_iam_role_policy_attachment" "ecs_exec_base" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach custom policy to allow SSM access for secrets injection
resource "aws_iam_policy" "ecs_execution_ssm_policy" {
  name        = "${var.app_name}-${var.environment}-ecs-execution-ssm"
  description = "Allows ECS execution role to fetch secrets from SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["ssm:GetParameter", "ssm:GetParameters"],
      Resource = [
        "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/pet-store/${var.environment}/db/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_ssm_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_ssm_policy.arn
}

# --------------------------
# ECS TASK ROLE
# --------------------------
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.app_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment
    Role        = "ecs-task"
  }
}

resource "aws_iam_policy" "ssm_access" {
  name        = "ecs-ssm-access-${var.environment}"
  description = "Allows ECS tasks to retrieve SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"],
      Resource = [
        "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/pet-store/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ssm_access.arn
}

# --------------------------
# ECS EC2 INSTANCE ROLE
# --------------------------
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.app_name}-${var.environment}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Environment = var.environment
    Role        = "ecs-instance"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.app_name}-${var.environment}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name

  tags = {
    Environment = var.environment
    Role        = "ecs-instance"
  }
}
