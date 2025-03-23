resource "aws_cloudwatch_log_group" "web_logs" {
  name              = "/ecs/${var.app_name}-web-${var.environment}-logs"
  retention_in_days = 14

  tags = {
    Environment = var.environment
    Service     = "web"
  }
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/ecs/${var.app_name}-api-${var.environment}-logs"
  retention_in_days = 14

  tags = {
    Environment = var.environment
    Service     = "api"
  }
}
