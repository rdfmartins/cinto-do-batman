variable "vpc_cidr" {
  description = "O bloco CIDR da VPC"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto para etiquetagem (tagging) de recursos"
  type        = string
}
