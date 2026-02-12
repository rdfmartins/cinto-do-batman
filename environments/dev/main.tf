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

# --- MÓDULO de BANCO DE DADOS (PERSISTÊNCIA) ---
module "database" {
  source = "../../modules/database"

  project_name = var.project_name
  environment  = var.environment

  # CONEXÃO: Aqui a mágica acontece. O Banco lê os IDs gerados pela Rede.
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids

  # Configurações do Banco
  db_name     = "coredb"
  db_user     = "admin"
  db_password = var.db_password
}
