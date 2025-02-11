
############################# Application load balancer #####################################


# Internet facing application load balancer

resource "aws_alb" "Keel_alb" {
  name = "Keel-alb"
  internal = false
  load_balancer_type = "application" 
  security_groups = [var.Keel_alb_sg]
  subnets = var.Keel_web_pubsub
  idle_timeout    = 400

  depends_on = [
    var.Keel_frontend_web_asg
  ]
}

# application load balancer target groups

# alb tg for http

resource "aws_alb_target_group" "Keel_alb_tg_http" {
  name = "Keel-alb-tg-http"
  port = var.tg_port
  protocol = var.tg_protocol
  vpc_id = var.Keel_vpc_id


  lifecycle {
    ignore_changes = [ name ]
    create_before_destroy = true
  }

  tags = {
    Name = "Keel_alb_tg_http"
  }
}


# application load balancer listener 

# alb listener for http

resource "aws_alb_listener" "Keel_alp_listener_http" {
  load_balancer_arn = aws_alb.Keel_alb.arn
  port = var.listener_port
  protocol = var.listener_protocol

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.Keel_alb_tg_http.arn
  }

  tags = {
    Name = "Keel_alp_listener_http"
  }
}
