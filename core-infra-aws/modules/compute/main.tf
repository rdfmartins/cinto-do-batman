# --- BUSCA DA IMAGEM (AMI) ---
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- IAM ROLE & PROFILE (SSM) ---
# Criação do "crachá" que permite à EC2 falar com o Systems Manager.

# 1. A Role (Identidade)
resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-${var.environment}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-ssm-role"
    Environment = var.environment
  }
}

# 2. Anexar a Policy Oficial da AWS para SSM (Core)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 3. O Instance Profile (O que anexamos na EC2)
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project_name}-${var.environment}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

# --- SECURITY GROUP ---
resource "aws_security_group" "compute_sg" {
  name        = "${var.project_name}-${var.environment}-compute-sg"
  description = "Security Group para instâncias com acesso via SSM"
  vpc_id      = var.vpc_id

  # NENHUMA regra de entrada (Ingress) é necessária para o SSM funcionar!
  # Isso é segurança máxima. O agente fala de dentro pra fora.
  # Deixamos HTTP apenas se quisermos rodar um servidor web.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access (Optional)"
  }

  # Regra de Saída (Egress): Essencial para o agente SSM falar com a API da AWS.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-compute-sg"
    Environment = var.environment
  }
}

# --- INSTÂNCIA EC2 ---
resource "aws_instance" "app_server" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  
  # Aqui entra a mágica do SSM:
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  # Rede
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.compute_sg.id]
  associate_public_ip_address = true # Ainda precisa de IP Público para falar com a API do SSM (a menos que tenhamos VPC Endpoints)

  tags = {
    Name        = "${var.project_name}-app-server"
    Environment = var.environment
  }
}