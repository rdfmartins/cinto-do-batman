# Core Infra (AWS) ☁️
> **Architecture as Code** | **Modular Design** | **Zero Trust Security**

Este projeto implementa uma fundação completa de infraestrutura na AWS, desenhada para escalar desde o primeiro dia. Não é apenas um conjunto de scripts Terraform, mas uma implementação de referência para **Engenharia de Plataforma Moderna**.

O foco está em entregar um ambiente pronto para produção, com governança de segurança e controle de custos (FinOps) nativos.

---

## 🏗️ Decisões de Arquitetura (Design Docs)

### ⚡ 1. Elasticidade & Dinamismo
Abandonamos a configuração estática.
*   **A Técnica:** Uso intensivo de `count` e `for_each` do Terraform.
*   **O Ganho:** O módulo de rede se adapta sozinho. Quer mudar de 2 para 3 Zonas de Disponibilidade (AZs)? Basta alterar uma variável. O código reescreve a infraestrutura sem intervenção manual.

### 🔒 2. Segurança "Zero Trust" (SSM)
Eliminamos a superfície de ataque mais comum em nuvem: a Porta 22 (SSH).
*   **A Técnica:** Implementação do **AWS Systems Manager (Session Manager)**.
*   **O Ganho:** Nenhuma chave `.pem` para gerenciar, nenhuma porta aberta para a internet. O acesso é auditado, temporário e criptografado pela AWS.

### 🧩 3. Modularidade & Injeção de Dependência
Cada componente (Rede, Banco, Computação) é isolado e agnóstico.
*   **A Técnica:** Uso de `outputs.tf` para passar dados entre módulos.
*   **O Ganho:** Redução do "Blast Radius" (Raio de Explosão). Uma mudança no banco de dados dificilmente quebrará a rede.

### 💰 4. FinOps Nativo
A infraestrutura nasce otimizada para o bolso.
*   **A Técnica:** Ambientes efêmeros com `skip_final_snapshot = true` e storage GP3/GP2 otimizado.
*   **O Ganho:** Facilidade para criar e destruir ambientes de laboratório sem gerar custos "fantasmas" (snapshots esquecidos).

---

## 🛠️ O Arsenal (Módulos)

### 🌐 Módulo de Rede (`modules/network`)
*   **VPC Customizada:** Controle total de CIDR e DNS.
*   **Isolamento:** Subnets Públicas (Internet) e Privadas (Dados/App).
*   **Roteamento:** Tabelas de rotas dedicadas e IGW gerenciado.

### 🗄️ Módulo de Banco de Dados (`modules/database`)
*   **RDS Seguro:** Instâncias isoladas na camada privada.
*   **Proteção:** Security Groups restritivos (apenas a VPC acessa).
*   **Engine:** PostgreSQL (Versão LTS).

### 💻 Módulo de Computação (`modules/compute`)
*   **EC2 SSM-Ready:** Instâncias com IAM Profiles automáticos para acesso seguro.
*   **AMI Inteligente:** Busca automática da imagem Amazon Linux 2023 mais recente.

---

## 🚀 Como Iniciar

### 1. Preparação (Bootstrap)
Execute o script de automação para verificar dependências e instalar ferramentas de qualidade (TFLint):

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 2. Deploy (Ambiente Dev)
```bash
cd environments/dev

# Inicialize o backend
terraform init

# Planeje a execução (O Terraform pedirá a senha do banco)
terraform plan

# Aplique a infraestrutura
terraform apply
```

---

## 📂 Estrutura do Repositório

```text
.
├── environments/        # Configurações por ambiente (dev, prod)
├── modules/             # Blocos de construção reutilizáveis
│   ├── network/         # Camada de Rede
│   ├── database/        # Camada de Dados
│   └── compute/         # Camada de Aplicação
└── bootstrap.sh         # Automação de Qualidade & Setup
```

---
**Mantido por Rodolfo Martins**