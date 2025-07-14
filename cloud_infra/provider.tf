terraform {
  backend "s3" {
  }
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "cicd" {
  source = "cicd"
}

#Placeholder for main.tf in dofs-project/terraform
