// variables.tf

variable "db_instance_identifier" {
  description = "The name of the PostgreSQL RDS instance."
  type        = string
  default     = "my-postgres-db"
}

variable "db_username" {
  description = "The username for the PostgreSQL database."
  type        = string
  default     = "myuser"
}

variable "db_password" {
  description = "The password for the PostgreSQL database."
  type        = string
  sensitive   = true
  default     = "mypassword"
}

variable "db_name" {
  description = "The name of the PostgreSQL database."
  type        = string
  default     = "mydatabase"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds."
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB."
  type        = number
  default     = 128
}
