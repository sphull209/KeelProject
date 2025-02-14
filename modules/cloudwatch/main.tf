
# modules/cloudwatch/main.tf

resource "aws_cloudwatch_log_group" "rds_log_group" {
  name = var.log_group_name
}

resource "aws_iam_role_policy_attachment" "rds_cloudwatch_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSMonitoringRole"
  role       = aws_iam_role.rds_monitoring_role.name
}
