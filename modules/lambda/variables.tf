// variables.tf

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds."
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB."
  type        = number
  default     = 128
}

variable "api_gateway_enabled" {
  description = "Flag to enable API Gateway for Lambda invocation."
  type        = bool
  default     = false
}
