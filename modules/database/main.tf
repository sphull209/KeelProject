####################### postgresSQL ##############################


# postgressql db

resource "aws_db_instance" "Keel_postgressql_db" {
  allocated_storage = 10
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = var.Keel-db-subnetgroup_name
  vpc_security_group_ids = [var.Keel_backend_db_tier_sg_id]
  identifier = var.db_identifier
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
  enable_cloudwatch_logs_exports = ["postgresql"]
  parameter_group_name = aws_db_parameter_group.my_postgresql_param_group.name
  skip_final_snapshot = "true"
  tags = {
    Name = "Keel_postgressql_db"
  }

} 


resource "aws_db_parameter_group" "my_postgresql_param_group" {
  name        = "my-postgresql-param-group"
  family      = "postgres14"
  description = "Custom parameter group for PostgreSQL logging"

  parameter {
    name  = "log_statement"
    value = "mod"  # Log INSERT, UPDATE, DELETE
  }

  parameter {
    name  = "log_duration"
    value = "1"  # Log query durations
  }

  parameter {
    name  = "log_line_prefix"
    value = "%m [%p] %d %r %u %a %t"  # Prefix for logs
  }

  parameter {
    name  = "log_connections"
    value = "true"
  }

  parameter {
    name  = "log_disconnections"
    value = "true"
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })
}
