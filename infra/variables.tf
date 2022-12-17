# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------

variable "acm_certificate_arn" {
  type        = string
  description = "AWS ACM Certificate ARN"
  default     = "arn:aws:acm:us-east-1:216761891772:certificate/32656f1c-e651-4d89-9741-15c7e9b5cf3d"
}
variable "domain_name" {
  type        = string
  default     = "oabcloudresumechallenge.com"
  description = "domain name"
}

variable "endpoint" {
  type        = string
  default     = "www.oabcloudresumechallenge.com"
  description = "endpoint url"
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "boris-crc"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "project name"
  default     = "cloud-resume-challenge"
}

variable "table_name" {
  type        = string
  description = "dynamodb table name"
  default     = "visitor-counter-crc"
}

variable "log_retention" {
  type        = number
  description = "log retention in days"
  default     = 14

}
