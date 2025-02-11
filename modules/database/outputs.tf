# --- database/outputs.tf ---

output "Keel_postgressql_db_endpoint" {
  value = aws_db_instance.Keel_postgressql_db.endpoint
  description = "endpoint url for postgressql db"
}
