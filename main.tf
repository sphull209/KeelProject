# define s3 remote backend

/*terraform {
  backend "s3" {
    bucket = "Keelremotebackend"
    dynamodb_table = "remotebackend_statelock_dynamodb"
    key = "Keelremotebackend/terraform.tfstate"
    encrypt = true
    region = "us-east-1"
  }
}*/

terraform {
  cloud {
    organization = "sphull209"

    workspaces {
      name = "AWSTerraform_KeelArch"
    }
  }
}

module "networking" {
 source = "./modules/networking"
 Keel_vpc_cidr = var.Keel_vpc_cidr
 access_ip = var.access_ip
 subnets_cidrs = var.subnets_cidrs
 azs = var.azs

}

module "compute" {
  source = "./modules/compute"
  key_name = var.key_name
  ami_value = var.ami_value
  instance_type = var.instance_type
  Keel_bastion_sg = module.networking.Keel_bastion_sg
  Keel_frontend_web_tier_sg = module.networking.Keel_frontend_web_tier_sg
  Keel_backend_app_tier_sg = module.networking.Keel_backend_app_tier_sg
  Keel_app_pvtsub = module.networking.Keel_app_pvtsub
  Keel_web_pubsub = module.networking.Keel_web_pubsub
  aws_alb_target_group_arn = module.loadbalancer.aws_alb_target_group_arn
  aws_alb_target_group_name = module.loadbalancer.aws_alb_target_group_name
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  Keel_alb_sg = module.networking.Keel_alb_sg
  Keel_web_pubsub = module.networking.Keel_web_pubsub
  Keel_frontend_web_asg = module.compute.Keel_frontend_web_asg
  tg_port = 80
  tg_protocol = "HTTP"
  Keel_vpc_id = module.networking.Keel_vpc_id
  listener_protocol = "HTTP"
  listener_port = 80
}

output "Keel_alb_endpoint" {
  value = module.loadbalancer.Keel_alb_endpoint
}



module "database" {
  source = "./modules/database"
  db_engine = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_username = var.db_username
  db_identifier = var.db_identifier
  db_password = var.db_password
  Keel-db-subnetgroup_name = module.networking.Keel-db-subnetgroup_name
  Keel_backend_db_tier_sg_id = module.networking.Keel_backend_db_tier_sg
}

module "lambda" {
  source = "./modules/lambda"
  lambda_function_name = "delete-record-lambda"
  lambda_role_name     = "lambda-execution-role"
  lambda_handler       = "lambda_function.lambda_handler"
  lambda_runtime       = "python3.9"
  lambda_zip_file      = "path_to_your_lambda_zip_file.zip"  # Provide the correct path
  timeout              = 60
  memory_size          = 128

  environment_variables = {
    DB_HOST     = "your-rds-instance-endpoint"
    DB_USER     = "your-db-username"
    DB_PASSWORD = "your-db-password"
    DB_NAME     = "your-db-name"
  }
}

# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"
}

module "ecs_task" {
  source = "./modules/ecs_task_module"

  task_definition_name = "my-ecs-task"
  execution_role_arn   = aws_iam_role.ecs_execution_role.arn
  task_role_arn        = aws_iam_role.ecs_task_role.arn
  cluster_id           = aws_ecs_cluster.ecs_cluster.id
  container_image      = "my-docker-image:latest"  # Update with your image URL
  service_name         = "my-ecs-service"
  db_host              = aws_db_instance.postgres_db.endpoint
  db_user              = var.db_user
  db_password          = var.db_password
  db_name              = var.db_name
  subnets              = var.subnets
  security_groups      = var.security_groups
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

module "cloudwatch" {
  source      = "./modules/cloudwatch"
  log_group_name = var.log_group_name
}
module "s3-artifact" {
  source = "./modules/s3-artifact"
  s3_artifact_bucket = var.s3_artifact_bucket
}
