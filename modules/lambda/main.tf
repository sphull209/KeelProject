
# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-postgres-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_rds_policy" {
  name        = "lambda-rds-policy"
  description = "Policy for Lambda to access RDS"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["rds:DescribeDBInstances", "rds-data:ExecuteStatement"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["logs:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}

# Lambda function to delete records from PostgreSQL
resource "aws_lambda_function" "delete_record_lambda" {
  function_name = "delete-record-lambda"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "delete-record-lambda.zip"  # Path to the ZIP file

  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size

  environment {
    variables = {
      DB_HOST     = module.rds_postgres.db_instance_address
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_NAME     = var.db_name
    }
  }
}
