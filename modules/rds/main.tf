resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*"
}

locals {
  db_name = "petstoredb"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.app_name}/${var.environment}/db/password"
  type  = "SecureString" # Encrypted using default KMS key
  value = random_password.db_password.result
  tags = {
    Name = "${var.app_name}-db-password"
  }
}

resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.app_name}/${var.environment}/db/host"
  type  = "String"
  value = aws_db_instance.rds.address
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.app_name}/${var.environment}/db/user"
  type  = "String"
  value = "admin"
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.app_name}/${var.environment}/db/port"
  type  = "String"
  value = "3306"
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.app_name}/${var.environment}/db/name"
  type  = "String"
  value = local.db_name
}

resource "aws_security_group" "rds" {
  name        = "${var.app_name}-${var.environment}-rds-sg"
  description = "Allow inbound traffic only from ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ecs_task_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-rds-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnets
  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.app_name}-${var.environment}-db"
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = aws_ssm_parameter.db_user.value
  password               = random_password.db_password.result
  db_name                = local.db_name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
}
