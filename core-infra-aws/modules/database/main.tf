terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- AGRUPAMENTO DE SUBNETS ---
# O RDS exige saber quais subnets ele pode usar. Agrupamos as privadas aqui.
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}

# --- SECURITY GROUP DO BANCO ---
# Controla quem entra e quem sai. Por padrão, fechado.
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security Group para o banco de dados RDS"
  vpc_id      = var.vpc_id

  # Regra de Saída: O banco pode falar com qualquer um (para updates, etc)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-rds-sg"
    Environment = var.environment
  }
}

# --- INSTÂNCIA RDS (POSTGRESQL) ---
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"

  # Configurações do Motor
  engine         = var.db_engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # Armazenamento
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"

  # Credenciais
  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  # Configurações de Rede
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false # Segurança total: nada de acesso público direto.

  # Configurações de Backup e Manutenção (Modo Efêmero)
  skip_final_snapshot = true # FinOps: Destruiu, apagou tudo (sem snapshot final cobrando).

  tags = {
    Name        = "${var.project_name}-rds"
    Environment = var.environment
  }
}
