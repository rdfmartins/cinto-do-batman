# --- IDENTIFICAÇÃO ---
variable "project_name" {
  description = "Prefixo para identificar os recursos do banco"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod, test)"
  type        = string
}

# --- CONECTIVIDADE ---
variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets onde o RDS ficará. A AWS exige pelo menos 2 em AZs diferentes."
  type        = list(string)
}

# --- CONFIGURAÇÃO TÉCNICA DO RDS ---
variable "db_engine" {
  description = "Motor do banco de dados (ex: postgres, mysql, mariadb)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Versão do motor do banco"
  type        = string
  default     = "15.7"
}

variable "instance_class" {
  description = "Potência da instância. t3.micro é excelente para testes rápidos e baixo custo."
  type        = string
  default     = "db.t3.micro"
}

# --- CREDENCIAIS ---
variable "db_name" {
  description = "Nome do banco de dados inicial"
  type        = string
  default     = "coredb"
}

variable "db_user" {
  description = "Usuário master do banco"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Senha master. Marcada como sensível para proteção de dados."
  type        = string
  sensitive   = true

  validation {
    condition     = !can(regex("[/@\" ]", var.db_password))
    error_message = "A senha do banco não pode conter os caracteres: '/', '@', '\"' ou espaços em branco."
  }
}

variable "allocated_storage" {
  description = "Espaço em disco (GB). 20GB é o mínimo e costuma entrar no Free Tier."
  type        = number
  default     = 20
}
