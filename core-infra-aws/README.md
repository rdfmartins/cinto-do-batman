# Core Infra (AWS)

Projeto de Infraestrutura como Código (IaC) focado em modularidade, segurança e otimização de custos (FinOps).

Este repositório implementa um ambiente de nuvem pronto para produção utilizando Terraform. A arquitetura foi projetada para ser altamente reutilizável, permitindo a implantação rápida de ambientes isolados enquanto mantém padrões rigorosos de segurança.

## Visão Geral da Arquitetura

A infraestrutura é decomposta em módulos independentes para garantir a separação de responsabilidades e facilitar a manutenção.

### Módulo de Rede (modules/network)
A camada fundamental da infraestrutura.
* **Implementação de VPC**: Blocos CIDR personalizados e configuração de DNS.
* **Subnetting em Camadas**: Implantação automatizada de subnets públicas e privadas em múltiplas Zonas de Disponibilidade (Multi-AZ).
* **Estratégia de Roteamento**: Tabelas de rotas isoladas para recursos privados e integração com Internet Gateway (IGW) para as camadas públicas.

### Módulo de Banco de Dados (modules/database)
* **Persistência Privada**: Instâncias RDS implantadas em subnets isoladas sem endpoints públicos.
* **Segurança de Acesso**: O acesso é gerenciado internamente pela VPC, sem a necessidade de Bastion Hosts expostos.
* **Gestão de Ciclo de Vida**: Otimizado para cargas de trabalho efêmeras visando a redução de custos operacionais.

### Módulo de Computação (modules/compute)
* **Acesso Seguro via SSM**: Instâncias EC2 gerenciadas via AWS Systems Manager Session Manager, eliminando a necessidade de chaves SSH e portas abertas.
* **IAM Roles**: Configuração de "Instance Profiles" com permissões mínimas necessárias para a operação.
* **AMI Dinâmica**: Busca automática da imagem mais recente do Amazon Linux 2023.

## Como Iniciar

### Pré-requisitos
* Terraform >= 1.0
* AWS CLI (configurado com as credenciais apropriadas)
* Ambiente Bash

### Automação de Estrutura (Scaffolding)
Disponibilizamos um script utilitário para inicializar a estrutura do projeto e preparar o ambiente para novos módulos.

```bash
chmod +x scaffold-infra.sh
./scaffold-infra.sh
```

### Processo de Implantação (Deploy)
Para implantar o ambiente de desenvolvimento:

```bash
# Dentro da pasta core-infra-aws/
cd environments/dev

terraform init
terraform plan

# O Terraform irá solicitar a senha do banco (variável db_password)
terraform apply
```

## Estrutura do Projeto

```text
.
├── environments/        # Configurações específicas por ambiente (dev, prod)
├── modules/             # Componentes de infraestrutura reutilizáveis
│   ├── network/         # Lógica e recursos de rede
│   ├── database/        # Lógica de persistência e banco de dados
│   └── compute/         # Lógica de computação e escalabilidade
└── scaffold-infra.sh    # Automação de estrutura do projeto
```

## Mantenedor
Rodolfo Martins