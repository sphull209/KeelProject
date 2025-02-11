# --- compute/outputs.tf ---

output "Keel_frontend_web_asg" {
  value = aws_autoscaling_group.Keel_frontend_web_asg.arn
  description = "The ARN of the frontend web Auto Scaling Group"
}

output "Keel_backend_app_asg" {
  value = aws_autoscaling_group.Keel_backend_app_asg.arn
  description = "The ARN of the backend app Auto Scaling Group"
}
