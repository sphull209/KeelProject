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

variable "access_ip" {
  type = string
  description = "specific ip address only permit for ssh into bastion instance"
}
