resource "aws_ecs_task_definition" "app_task" {
  family                = var.task_definition_name
  execution_role_arn    = var.execution_role_arn
  task_role_arn         = var.task_role_arn
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = jsonencode([{
    name      = "app-container"
    image     = var.container_image
    essential = true
    environment = [
      {
        name  = "DB_HOST"
        value = var.db_host
      },
      {
        name  = "DB_USER"
        value = var.db_user
      },
      {
        name  = "DB_PASSWORD"
        value = var.db_password
      },
      {
        name  = "DB_NAME"
        value = var.db_name
      }
    ]
  }])
}

resource "aws_ecs_service" "app_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
