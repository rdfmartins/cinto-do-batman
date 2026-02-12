# --- VPC: O Coração da Rede ---
# Aqui definimos o espaço isolado na AWS onde todos os recursos viverão.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Essencial para que instâncias tenham nomes amigáveis (ex: RDS)
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# --- SUBNETS PÚBLICAS ---
# Usamos 'count' para criar múltiplas subnets dinamicamente.
resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[count.index]
  # O element() faz o 'giro' nas AZs: se tivermos 3 subnets e 2 AZs, a 3ª volta para a primeira AZ.
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true # Garante que recursos aqui ganhem IP público automaticamente

  tags = {
    Name        = "${var.project_name}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# --- SUBNETS PRIVADAS ---
# Onde guardamos os segredos (Bancos de Dados, Backend).
resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.project_name}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# --- INTERNET GATEWAY (IGW) ---
# A porta de entrada e saída para a internet. Sem ele, a VPC fica isolada do mundo.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# --- TABELA DE ROTAS PÚBLICAS ---
# O 'GPS' da rede. Diz para onde o tráfego deve ir.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Rota padrão: Todo tráfego destinado à internet (0.0.0.0/0) vai para o IGW.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# --- ASSOCIAÇÃO DAS ROTAS ---
# Aqui 'carimbamos' as subnets públicas para usarem a tabela de rotas pública.
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
