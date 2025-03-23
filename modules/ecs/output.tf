output "ecs_task_sg_id" {
  description = "ECS Security Group ID"
  value       = aws_security_group.ecs_task_sg.id
}
