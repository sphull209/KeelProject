output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app_task.arn
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.app_service.name
}
