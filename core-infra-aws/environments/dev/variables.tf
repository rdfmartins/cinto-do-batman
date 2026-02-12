variable "aws_region" {
  description = "Região da AWS para o ambiente de dev"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "core-infra"
}

variable "environment" {
  description = "Ambiente de execução"
  type        = string
  default     = "dev"
}

# --- SENHAS E SEGURANÇA ---
variable "db_password" {
  description = "Senha do banco de dados RDS. Deve ser passada via variável de ambiente ou arquivo .tfvars"
  type        = string
  sensitive   = true
}