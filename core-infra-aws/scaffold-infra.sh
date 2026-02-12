#!/bin/bash

# Define as cores para saída
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Iniciando a criação da estrutura do projeto Terraform...${NC}"

# Criando diretórios dos módulos
echo "Criando diretórios em modules/..."
mkdir -p modules/network
mkdir -p modules/database
mkdir -p modules/compute

# Criando diretório de ambiente
echo "Criando diretórios em environments/..."
mkdir -p environments/dev

# Criando arquivos vazios para iniciar
echo "Criando arquivos de configuração em environments/dev/..."
touch environments/dev/main.tf
touch environments/dev/variables.tf

echo -e "${GREEN}Estrutura criada com sucesso!${NC}"

# Listando a estrutura criada
if command -v tree &> /dev/null; then
    tree
else
    ls -R
fi
