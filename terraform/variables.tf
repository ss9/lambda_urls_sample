variable "aws_account" {
  description = "The AWS account id to create things in."
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "aws_shared_credentials_file" {
  description = "AWS credentail file"
  default     = "~/.aws/credentials"
}
variable "stack" {
  description = "Name of the stack."
  default     = "default"
}

variable "image_uri" {
  description = "Name of the stack."
}

variable "lambda_arch" {
  description = "Name of the stack."
  default     = "arm64"
}

variable "lambda_memory" {
  description = "Name of the stack."
  default     = 128
}

variable "lambda_storage" {
  description = "Name of the stack."
  default     = 512
}

variable "lambda_timeout" {
  description = "Name of the stack."
  default     = 3
}
