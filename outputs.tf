output "load_balancer_endpoint" {
  value = module.loadbalancer.Keel_alb_endpoint
}

output "db_endpoint" {
  value = module.database.Keel_postgressql_db_endpoint
}
