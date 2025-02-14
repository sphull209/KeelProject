variable "aws_region" {
  type = string
  description = "aws region of our architecture"
}

variable "azs" {
  type = list(string)
  description = "list of availability zones"
}

variable "Keel_vpc_cidr" {
  type = string
  description = "cidr block of Keel vpc"
}

variable "subnets_cidrs" {
  type = list(string)
  description = "List of CIDR blocks for subnets (web, app, and db tiers)"
}

variable "key_name" {
  type = string
  description = "aws key pair name"
}

variable "ami_value" {
  type = string
  description = "ami id used for autoscaling groups"
}

variable "instance_type" {
  type = string
  description = "instance type for autoscaling groups "
}

variable "db_username" {
  type = string
  description = "Keel postgressql db username"
}

variable "db_password" {
  type = string
  description = "Keel postgressql db password"
}

variable "db_engine" {
  type = string
  description = "Keel postgressql db engine type"
}

variable "db_engine_version" {
  type = string
  description = "Keel postgressql db engine version"
}

variable "db_instance_class" {
  type = string
  description = "Keel postgressql db instance class(type)"
}

variable "db_identifier" {
  type = string
  description = "Keel postgressql db identifier"
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "/aws/rds/instance/my-rds-instance/logs"
}

variable "access_ip" {
  type = string
  description = "sepcific ip address only permit for ssh into bastion instance"
}

variable "s3_artifact_bucket" {
  description = "Name of the S3 bucket for artifact storage"
}
