# aws region for our architecture
aws_region = "us-east-1"

# availability zones
azs = ["us-east-1a" , "us-east-1b"]

#cidr block of vpc
Keel_vpc_cidr = "10.0.0.0/16"


# list of CIDR blocks for subnets
subnets_cidrs = [
    "10.0.1.0/24", # Web subnet 1a
    "10.0.2.0/24", # Web subnet 1b
    "10.0.3.0/24", # App subnet 1a
    "10.0.4.0/24", # App subnet 1b
    "10.0.5.0/24", # DB subnet 1a
    "10.0.6.0/24"  # DB subnet 1b
  ]

# aws key pair name
key_name = "Keel_bastion_key"

# ami value
ami_value = "ami-0166fe664262f664c"

# instance type value
instance_type = "t2.micro"

# Keel postgressql db username
db_username = "db_admin"

# Keel postgressql db password
db_password = "Admin123"

# Keel postgressql db engine type
db_engine = "postgres"

# Keel postgressql db engine version
db_engine_version = "14.1"

# Keel postgressql db instance class(type)
db_instance_class = "db.t3.micro"

# Keel postgressql db identifier
db_identifier = "Keeldb"

# access ip for bastion instance
access_ip = "0.0.0.0/0"

# name of the S3 bucket for artifact storage
s3_artifact_bucket = "Keels3artifact"
