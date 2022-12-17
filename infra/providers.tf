terraform {
  backend "remote" {
    organization = "snstech"
    workspaces {
      name = "oab-crc-terraform"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  required_version = "~> 1.0"
}


##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "random" {
}

provider "local" {
}