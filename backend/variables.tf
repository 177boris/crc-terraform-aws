# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------


variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "oab-crc"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "project name"
  default     = "cloud-resume-challenge"
}

