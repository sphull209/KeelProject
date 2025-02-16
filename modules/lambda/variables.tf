# lambda_module/variables.tf

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_role_name" {
  description = "The name of the IAM role for the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "The function handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "lambda_zip_file" {
  description = "The path to the Lambda function zip file"
  type        = string
}

variable "timeout" {
  description = "The timeout for the Lambda function"
  type        = number
  default     = 60
}

variable "memory_size" {
  description = "The memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}
