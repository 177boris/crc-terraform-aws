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
      version = "~> 4.40.0"
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

provider "random" {
}

provider "local" {
}