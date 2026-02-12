# Core Infra (AWS)

Projeto de Infraestrutura como Código (IaC) focado em modularidade, segurança e otimização de custos (FinOps).

Este repositório implementa um ambiente de nuvem pronto para produção utilizando Terraform. A arquitetura foi projetada para ser altamente reutilizável, permitindo a implantação rápida de ambientes isolados enquanto mantém padrões rigorosos de segurança.

## Destaques de Engenharia & Técnicas

Além da infraestrutura básica, este projeto demonstra o uso de padrões avançados de Terraform e AWS:

### 1. Dynamic Subnetting (Loops & Functions)
Em vez de declarar recursos estáticos, utilizamos a meta-argumento `count` e funções como `element` para criar subnets dinamicamente baseadas na quantidade de zonas de disponibilidade (AZs) desejadas.
*   **Benefício:** O código se adapta automaticamente se quisermos mudar de 2 para 3 AZs apenas alterando uma variável.

### 2. Zero-Trust Access (SSM vs SSH)
Adotamos uma postura de segurança moderna eliminando a necessidade de chaves SSH (`.pem`) e portas de entrada (Inbound Rules) abertas para a internet.
*   **Técnica:** Utilizamos o **AWS Systems Manager (Session Manager)**. A instância EC2 possui uma IAM Role que permite ao agente SSM se conectar à API da AWS de "dentro para fora".
*   **Resultado:** Redução drástica da superfície de ataque (Porta 22 fechada).

### 3. State Isolation & Data Injection
Os módulos são projetados para serem agnósticos. Eles não "sabem" valores hardcoded.
*   **Técnica:** Uso intensivo de `outputs.tf` para exportar IDs (VPC, Subnets) e injetá-los como dependência em outros módulos (Ex: O módulo de Computação consome o ID da VPC gerado pelo módulo de Rede).

### 4. FinOps & Ambientes Efêmeros
O banco de dados foi configurado com `skip_final_snapshot = true` e storage otimizado para desenvolvimento.
*   **Objetivo:** Permitir que o comando `terraform destroy` seja executado sem deixar "faturas fantasmas" (snapshots órfãos) na conta AWS, facilitando a criação e destruição de ambientes de laboratório.

---

## Visão Geral da Arquitetura

A infraestrutura é decomposta em módulos independentes:

### Módulo de Rede (modules/network)
* **VPC**: Blocos CIDR parametrizáveis.
* **Subnetting**: Separação física entre camadas Públicas e Privadas.
* **Routing**: Tabelas de rotas dedicadas.

### Módulo de Banco de Dados (modules/database)
* **RDS Privado**: Bancos de dados isolados da internet pública.
* **Security Groups**: Regras restritivas de acesso.

### Módulo de Computação (modules/compute)
* **EC2 + SSM**: Instâncias gerenciadas sem Bastion Host.
* **AMI Dinâmica**: Uso de `data sources` para buscar sempre a imagem Linux mais atual.

## Como Iniciar

### Pré-requisitos
* Terraform >= 1.0
* AWS CLI configurado

### Automação (Scaffolding)
```bash
chmod +x scaffold-infra.sh
./scaffold-infra.sh
```

### Deploy (Dev Environment)
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Estrutura do Projeto

```text
.
├── environments/        # Configurações (dev, prod)
├── modules/             # Blocos de construção (network, database, compute)
└── scaffold-infra.sh    # Automação
```

## Mantenedor
Rodolfo Martins
