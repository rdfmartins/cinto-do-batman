# --- IDENTIFICAÇÃO ---
variable "project_name" {
  description = "Nome do projeto para tags"
  type        = string
}

variable "environment" {
  description = "Ambiente de execução (dev, prod)"
  type        = string
}

# --- REDE ---
variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "public_subnet_id" {
  description = "ID da Subnet Pública onde a EC2 será lançada"
  type        = string
}

# --- CONFIGURAÇÃO DA MÁQUINA ---
variable "instance_type" {
  description = "Tipo da instância EC2 (ex: t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID da AMI. Se vazio, usa Amazon Linux 2023 (que já vem com agente SSM instalado)."
  type        = string
  default     = ""
}