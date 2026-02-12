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

# --- MÓDULO DE REDE ---
module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
}

# --- MÓDULO DE BANCO DE DADOS (PERSISTÊNCIA) ---
module "database" {
  source = "../../modules/database"

  project_name = var.project_name
  environment  = var.environment

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids

  db_name     = "coredb"
  db_user     = "admin"
  db_password = var.db_password
}

# --- MÓDULO DE COMPUTAÇÃO (APPLICATION TIER) ---
module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment

  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_ids[0] # Usando a primeira subnet pública
  instance_type    = "t3.micro"
}