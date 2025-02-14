// output.tf

output "lambda_function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.delete_record_lambda.function_name
}
