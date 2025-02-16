# lambda_module/main.tf

resource "aws_iam_role" "lambda_execution_role" {
  name               = var.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "delete_record_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  filename      = var.lambda_zip_file
  timeout       = var.timeout
  memory_size   = var.memory_size

  environment {
    variables = var.environment_variables
  }
}
