terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  # Passando as variáveis para o módulo
  project_name = var.project_name
  environment  = var.environment

  # Definições de Rede para DEV
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
}