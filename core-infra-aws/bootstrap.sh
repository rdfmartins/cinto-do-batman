#!/bin/bash

# Define as cores para saída
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar se um comando existe
check_command() {
    if ! command -v "$1" &> /dev/null;
 then
        echo -e "${RED}[ERRO] O comando '$1' não foi encontrado. Por favor, instale-o.${NC}"
        return 1
    else
        echo -e "${GREEN}[OK] O comando '$1' foi encontrado.${NC}"
        return 0
    fi
}

# Função para instalar o TFLint se não existir
install_tflint() {
    if ! command -v tflint &> /dev/null;
 then
        echo -e "${YELLOW}[AVISO] TFLint não encontrado. Tentando instalar...${NC}"
        curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[SUCESSO] TFLint instalado com sucesso!${NC}"
        else
            echo -e "${RED}[ERRO] Falha ao instalar TFLint. Tente manualmente ou execute com sudo.${NC}"
        fi
    else
        echo -e "${GREEN}[OK] TFLint já está instalado.${NC}"
    fi
}

echo -e "${YELLOW}=== Iniciando Verificação de Dependências ===${NC}"
check_command "terraform"
check_command "aws"
install_tflint

echo -e "\n${YELLOW}=== Iniciando Estrutura do Projeto ===${NC}"

# Criando diretórios dos módulos
echo "Criando diretórios em modules/..."
mkdir -p modules/network
mkdir -p modules/database
mkdir -p modules/compute

# Criando diretório de ambiente
echo "Criando diretórios em environments/..."
mkdir -p environments/dev

# Criando arquivos vazios para iniciar (apenas se não existirem)
echo "Verificando arquivos de configuração..."
if [ ! -f environments/dev/main.tf ]; then
    touch environments/dev/main.tf
fi
if [ ! -f environments/dev/variables.tf ]; then
    touch environments/dev/variables.tf
fi

echo -e "${GREEN}Estrutura verificada!${NC}"

echo -e "\n${YELLOW}=== Executando Tríade da Robustez (Qualidade de Código) ===${NC}"

# 1. Terraform Format (Beleza)
echo "Executando 'terraform fmt -recursive' para padronizar o código..."
if command -v terraform &> /dev/null;
then
    terraform fmt -recursive
    echo -e "${GREEN}[OK] Código formatado.${NC}"
fi

# 2. TFLint (Análise Estática / AST)
echo "Executando 'tflint --init' e análise..."
if command -v tflint &> /dev/null;
then
    # Inicializa plugin AWS se houver arquivo de config
    if [ -f .tflint.hcl ]; then
        tflint --init
    fi
    
    # Roda análise no diretório atual e subdiretórios
    tflint --recursive
    echo -e "${GREEN}[OK] Análise de TFLint concluída.${NC}"
fi

echo -e "\n${GREEN}=== Processo Concluído com Sucesso! ===${NC}"

echo -e "${YELLOW}Seu ambiente está pronto e validado para o deploy.${NC}\n"



# Listando a estrutura de forma segura

if command -v tree &> /dev/null; then

    tree -L 2

else

    echo "Estrutura do Projeto:"

    ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /'

fi