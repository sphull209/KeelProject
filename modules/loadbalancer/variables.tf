# --- loadbalancing/outputs.tf --- 

variable "Keel_alb_sg" {
    type = string
    description = "The ID of the security group for the alb"
}
variable "Keel_web_pubsub" {
    type = list(string)
    description = "the ID's of the web tier public subnets in both az's"
}
variable "Keel_frontend_web_asg" {
    type = string
    description = "the ARN of the frontend web Auto Scaling Group"
}
variable "tg_port" {
    type = number
    description = "tg group port"
}

variable "tg_protocol" {
    type = string
    description = "target group protocol"
}

variable "Keel_vpc_id" {
    type = string
    description = "id of the vpc"
}

variable "listener_protocol" {
    type = string
    description = "alb listener protocol"
}

variable "listener_port" {
    type = number
    description = "alb listener port"
}
