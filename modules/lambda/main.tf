resource "aws_lambda_function" "delete_record_lambda" {
  function_name = "delete-record-lambda"
  runtime       = "python3.11"
  role          = module.lambda_iam_role.role_arn
  handler       = "lambda_function.lambda_handler"
  filename      = "delete-record-lambda.zip"  # Path to the ZIP file

  environment {
    variables = {
      DB_HOST     = module.rds_postgres.db_instance_address
      DB_USER     = "myuser"
      DB_PASSWORD = "mypassword"
      DB_NAME     = "mydatabase"
    }
  }
}
