############## Compute ################


# launch template and auto scaling group for bastion

resource "aws_launch_template" "keel_bastion" {
  name                   = "keel-bastion"
  image_id               = var.ami_value
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.keel_bastion_sg]
  key_name               = var.key_name

  tags = {
    Name = "keel_bastion"
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name = "bastion-ASG"
  vpc_zone_identifier = var.keel_web_pubsub
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1

  launch_template {
    id = aws_launch_template.keel_bastion.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "keel_bastion"
    propagate_at_launch = true
  }

}


# launch template and auto scaling group for frontend web-app on web tier

resource "aws_launch_template" "keel_frontend_web_lt" {
  name                   = "keel-frontend-web-lt"
  image_id               = var.ami_value
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.keel_frontend_web_tier_sg]
  key_name               = var.key_name
  iam_instance_profile {
    name                 = "s3_artifact_instance_profile"
  }
  user_data              = filebase64("install_apache.sh")

  tags = {
    Name = "keel_frontend_web"
  }
}

resource "aws_autoscaling_group" "keel_frontend_web_asg" {
  
  name = "keel-frontend-web-asg"
  vpc_zone_identifier = var.keel_web_pubsub
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2


  launch_template {
    id      = aws_launch_template.keel_frontend_web_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.aws_alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "keel_frontend_web"
    propagate_at_launch = true
  }
  
  health_check_type = "EC2"
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.keel_frontend_web_asg.id
  lb_target_group_arn    = var.aws_alb_target_group_arn
}

# launch template and auto scaling group for backend app on app tier

resource "aws_launch_template" "keel_backend_app_lt" {
  name_prefix               = "keel-backend-app-lt"
  image_id                  = var.ami_value
  instance_type             = var.instance_type
  vpc_security_group_ids    = [var.keel_backend_app_tier_sg]
  key_name                  = var.key_name
  iam_instance_profile {
    name = "s3_artifact_instance_profile"
  }
  user_data = filebase64("install_node.sh")
  
  tags = {
    Name = "keel_backend_app"
  }
}

resource "aws_autoscaling_group" "keel_backend_app_asg" {
  name = "keel-backend-app-asg"
  vpc_zone_identifier = var.keel_app_pvtsub
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2

  launch_template {
    id = aws_launch_template.keel_backend_app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "keel_backend_app"
    propagate_at_launch = true
  }

}
