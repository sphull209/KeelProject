variable "task_definition_name" {
  description = "The name of the ECS task definition"
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the execution role for the ECS task"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the task role for the ECS task"
  type        = string
}

variable "container_image" {
  description = "The Docker image for the ECS container"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "db_host" {
  description = "The hostname of the PostgreSQL database"
  type        = string
}

variable "db_user" {
  description = "The username for the PostgreSQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
}

variable "cpu" {
  description = "The CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "The memory for the ECS task"
  type        = string
  default     = "512"
}

variable "subnets" {
  description = "The list of subnets for the ECS service"
  type        = list(string)
}

variable "security_groups" {
  description = "The list of security groups for the ECS service"
  type        = list(string)
}
