# --- database/variables.tf ---

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

variable "Keel-db-subnetgroup_name" {
  type = string
  description = "name of the db subnet group"
}

variable "monitoring_interval" {
  description = "Monitoring interval (seconds)"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
}

variable "Keel_backend_db_tier_sg_id" {
  type = string
  description = "id of security group assisgned to backend db"
}
