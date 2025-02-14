
################################ Networking ####################

# VPC Configuartion

resource "aws_vpc" "Keel_vpc" {
  cidr_block = var.Keel_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Keel_vpc"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# internet gateway for project VPC

resource "aws_internet_gateway" "Keel_igw" {
  vpc_id = aws_vpc.Keel_vpc.id
  tags = {
    Name = "Keel_igw"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Public subnets for web-tier

resource "aws_subnet" "Keel_web_pubsub" {
  count = length(var.azs) #This will create a number of subnets equal to the number of Availability Zones in var.azs. ie,2
  vpc_id = aws_vpc.Keel_vpc.id
  cidr_block = var.subnets_cidrs[count.index] # CIDR for the web tier from list
  availability_zone = var.azs[count.index] # az's from the list
  map_public_ip_on_launch = true

  tags = {
  Name = "Keel_web_pubsub_${substr(var.azs[count.index], -2, 2)}"
}
}  


# Private subnets for app-tier

resource "aws_subnet" "Keel_app_pvtsub" {
  count = length(var.azs) #This will create a number of subnets equal to the number of Availability Zones in var.azs. ie,2
  vpc_id = aws_vpc.Keel_vpc.id
  cidr_block = var.subnets_cidrs[count.index + 2] # CIDR for the web tier from list
  availability_zone = var.azs[count.index] # az's from the list
  map_public_ip_on_launch = false

  tags = {
  Name = "Keel_app_pvtsub_${substr(var.azs[count.index], - 2, 2)}"
}
}


# private subnets for database-tier

resource "aws_subnet" "Keel_db_pvtsub" {
  count = length(var.azs)
  vpc_id = aws_vpc.Keel_vpc.id
  cidr_block = var.subnets_cidrs[count.index + 4]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Keel_db_pvtsub_${substr(var.azs[count.index], - 2, 2)}"
  }
}

# elastic IP for NAT

resource "aws_eip" "eip_nat" {
  tags = {
    name = "eip_nat"
  }
}

# NAT gateway for project vpc

resource "aws_nat_gateway" "Keel_nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id = aws_subnet.Keel_web_pubsub[0].id
  tags = {
    Name = "Keel_nat"
  }

  depends_on = [ aws_internet_gateway.Keel_igw ]
}

# public route table

resource "aws_route_table" "Keel_public_rt" {
  vpc_id = aws_vpc.Keel_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Keel_igw.id
  }

  tags = {
    Name = "Keel_pub_rt"
  }
}

# private route table

resource "aws_route_table" "Keel_pvt_rt" {
  vpc_id = aws_vpc.Keel_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Keel_nat.id
  }

  tags = {
    Name = "Keel_pvt_rt" 
  }
}

# route table association for web-tier subnets

resource "aws_route_table_association" "web_route_association" {
  count = length(var.azs)
  subnet_id = aws_subnet.Keel_web_pubsub[count.index].id
  route_table_id = aws_route_table.Keel_public_rt.id
}

# route table association for app-tier subnets

 resource "aws_route_table_association" "app_route_association" {
   count = length(var.azs)
   subnet_id = aws_subnet.Keel_app_pvtsub[count.index].id
   route_table_id = aws_route_table.Keel_pvt_rt.id
 }

 # route table association for db-tier subnets

 resource "aws_route_table_association" "db_route_association" {
   count = length(var.azs)
   subnet_id = aws_subnet.Keel_db_pvtsub[count.index].id
   route_table_id = aws_route_table.Keel_pvt_rt.id
 }

#security groups

#Bastion security group

resource "aws_security_group" "Keel_bastion_sg" {
  name = "bastion-sg"
  description = "allow ssh access from internet"
  vpc_id = aws_vpc.Keel_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    name = "bastion-sg"
  }
}

# ALB SG

resource "aws_security_group" "Keel_alb_sg" {
  description = "security group allows http and https from internet"
  name = "Keel-alb-sg"
  vpc_id = aws_vpc.Keel_vpc.id

  ingress {
    description = "allow http access from internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow flask port"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "Keel_alb_sg"
  }

}

# frontend web tier sg

resource "aws_security_group" "Keel_frontend_web_tier_sg" {
  description = "allow http inbound from loadbalancer sg and ssh inbound from bastion sg"
  name = "Keel-frontend-web-sg"
  vpc_id = aws_vpc.Keel_vpc.id

  ingress {
    description = "allow http inbound from loadbalancer security group"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.Keel_alb_sg.id]
  }

  ingress {
    description     = "Allow SSH from Bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.Keel_bastion_sg.id]  # Bastion SG as source
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "Keel_frontend_web_tier_sg"
  }

}

# backend app tier sg

resource "aws_security_group" "Keel_backend_app_tier_sg" {
  description = "allow http inbound from frontend_web_sg and ssh inbound from bastion"
  name = "Keel-backend-app-sg"
  vpc_id = aws_vpc.Keel_vpc.id
  
  ingress {
    description = "allow all inblund from frontend_web_sg"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    security_groups = [aws_security_group.Keel_frontend_web_tier_sg.id]
  }

  ingress {
    description = "allow ssh from bastion "
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.Keel_bastion_sg.id]
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "Keel_backend_app_tier_sg"
  }
}

# backend(db tier) db sg

resource "aws_security_group" "Keel_backend_db_tier_sg" {
  description = "allow MySql port inbound from Keel_backend_app_tier_sg"
  name = "Keel-backend-db-tier-sg"
  vpc_id = aws_vpc.Keel_vpc.id

  ingress {
    description = "allow MySql port Keel_backend_app_tier_sg"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.Keel_backend_app_tier_sg.id]
  }

  egress {
    description = "allow all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "Keel_backend_db_tier_sg"
  }

}

#database subnet group

resource "aws_db_subnet_group" "Keel_db_subnetgroup" {
  name       = "Keel-rds-subnetgroup"
  subnet_ids = aws_subnet.Keel_db_pvtsub[*].id

  tags = {
    Name = "Keel_rds_subnetgroup"
  }
}
