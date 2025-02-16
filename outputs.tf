output "load_balancer_endpoint" {
  value = module.loadbalancer.Keel_alb_endpoint
}

output "db_endpoint" {
  value = module.database.Keel_postgressql_db_endpoint
}

output "ecs_service_name" {
  description = "The ECS service name"
  value       = module.ecs_task.ecs_service_name
}
