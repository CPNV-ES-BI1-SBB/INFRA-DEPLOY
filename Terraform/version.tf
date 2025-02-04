terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
    sops = {
        source  = "carlpett/sops"
        version = "1.1.1"
    }
  }
}

provider "aws" {
    region = "eu-south-1"
    access_key = data.sops_file.secrets.data["aws_access_key"]
    secret_key = data.sops_file.secrets.data["aws_secret_key"]
}

provider "sops" {}