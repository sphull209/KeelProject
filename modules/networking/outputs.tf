# --- networking/outputs.tf ---

output "Keel_alb_sg_id" {
  value = aws_security_group.Keel_alb_sg.id
  description = "id of alb sg"
}

output "Keel_vpc_id" {
  value = aws_vpc.Keel_vpc.id
  description = "id of three tier vpc"
}

output "Keel-db-subnetgroup_name" {
  value = aws_db_subnet_group.Keel_db_subnetgroup.name
  description = "name of the db subnet group"
}

output "Keel-db-subnetgroup_id" {
  value = aws_db_subnet_group.Keel_db_subnetgroup.id
  description = "id of the db subnet group"
}

output "Keel_backend_db_tier_sg" {
  value = aws_security_group.Keel_backend_db_tier_sg.id
  description = "id of the db security group"
}

output "Keel_bastion_sg" {
  value = aws_security_group.Keel_bastion_sg.id
  description = "id of the bastion security group"
}

output "Keel_alb_sg" {
  value = aws_security_group.Keel_alb_sg.id
  description = "id of the alb security group"
}

output "Keel_frontend_web_tier_sg" {
  value = aws_security_group.Keel_frontend_web_tier_sg.id
  description = "id of the web tier security group"
}

output "Keel_backend_app_tier_sg" {
  value = aws_security_group.Keel_backend_app_tier_sg.id
  description = "id of the app tier security group"
}

output "Keel_web_pubsub" {
  value = aws_subnet.Keel_web_pubsub.*.id
  description = "id's of the public subnets "
}

output "Keel_app_pvtsub" {
  value = aws_subnet.Keel_app_pvtsub.*.id
  description = "id's of the private subnets"
}
