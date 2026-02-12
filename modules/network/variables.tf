variable "project_name" {
  description = "Nome do projeto. Usado para prefixar recursos e garantir nomes únicos e rastreabilidade (Tagging Strategy)."
  type        = string
  default     = "cinto-do-batman"
}

variable "environment" {
  description = "Define o estágio da infraestrutura (dev, staging, prod). Crítico para segregar recursos e controle de custos."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "Bloco IP principal da VPC. Escolher um bloco /16 evita falta de IPs no futuro."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  # --- PULO DO GATO DO ARQUITETO ---
  # Receber uma lista nos permite ser flexíveis.
  # Se passarmos apenas ["us-east-1a"], o módulo cria uma estrutura econômica (Single AZ).
  # Se passarmos ["us-east-1a", "us-east-1b"], ele cria Alta Disponibilidade (Multi-AZ) automaticamente.
  description = "Lista de zonas de disponibilidade. Controla a redundância da rede."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_cidr" {
  description = "CIDRs para subnets públicas. Devem corresponder à quantidade de AZs se quisermos simetria."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "CIDRs para subnets privadas. Onde ficam os recursos protegidos (bancos, apps)."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
