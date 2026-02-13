# Core Infra (AWS)
> **Architecture as Code** | **Modular Design** | **FinOps First**

Fundação de infraestrutura AWS focada em desenvolvimento rápido e arquitetura de referência. Este projeto demonstra padrões modernos de IaC (Infrastructure as Code) com Terraform modular, priorizando velocidade de provisionamento e custo zero quando destruído.

**Propósito:** Ambiente de desenvolvimento/testes que serve como base para aprendizado e prototipagem, implementando conceitos de segurança moderna (Zero Trust via SSM) e design modular escalável.

---

## Escopo & Limitações

**Este é um ambiente de DEV otimizado para:**
- Prototipagem rápida de aplicações
- Testes de integração AWS
- Aprendizado de Terraform modular
- Demonstração de padrões arquiteturais

**Não inclui (por design):**
- Backups automáticos (RDS com `retention = 0`)
- Criptografia at-rest
- NAT Gateway (subnets privadas sem saída para internet)
- Secrets Manager (senha via variável local)
- Monitoring/Alertas (CloudWatch)
- Alta disponibilidade (instância única, sem ASG)

> Nota: Para requisitos de produção, consulte a seção "Roadmap para Produção" no final deste documento.

---

## Decisões de Arquitetura (Design Docs)

### 1. Elasticidade & Dinamismo
Abandono de configurações estáticas em favor de flexibilidade.
*   **Técnica:** Uso de `count` e `for_each` do Terraform.
*   **Resultado:** O módulo de rede adapta-se dinamicamente. A alteração da quantidade de Zonas de Disponibilidade (AZs) exige apenas a atualização de uma variável, sem intervenção manual no código core.

### 2. Segurança Zero Trust (SSM)
Eliminação da superfície de ataque via Porta 22 (SSH).
*   **Técnica:** Implementação do AWS Systems Manager (Session Manager).
*   **Resultado:** Gestão simplificada de acesso sem chaves .pem, com tráfego auditado e criptografado nativamente pela AWS.
*   **Trade-off:** Porta 80 liberada para testes HTTP. Em ambientes produtivos, recomenda-se a substituição por Application Load Balancer (ALB) com HTTPS.

### 3. Modularidade & Injeção de Dependência
Isolamento lógico entre Rede, Banco e Computação.
*   **Técnica:** Comunicação entre módulos via `outputs.tf`.
*   **Resultado:** Redução do Raio de Explosão (Blast Radius). Alterações em camadas de dados ou computação não impactam a estabilidade da rede base.

### 4. FinOps Nativo
Otimização para custo zero em ambientes efêmeros.
*   **Técnica:** `skip_final_snapshot = true`, instâncias da família t3, storage GP3 mínimo.
*   **Resultado:** Ciclos de criação e destruição de ambientes sem custos residuais (volumes ou snapshots órfãos).

---

## Módulos do Projeto

### Módulo de Rede (modules/network)
* VPC Customizada com controle total de CIDR.
* Segregação entre Subnets Públicas e Privadas.
* Tabelas de rotas dedicadas e Internet Gateway (IGW).

### Módulo de Banco de Dados (modules/database)
* Instâncias RDS PostgreSQL isoladas na camada privada.
* Security Groups restritivos com acesso limitado à VPC.

### Módulo de Computação (modules/compute)
* Instâncias EC2 configuradas para acesso via SSM.
* Busca dinâmica da AMI Amazon Linux 2023 mais recente.

---

## Instruções de Uso

### Pré-requisitos
- AWS CLI configurado
- Terraform >= 1.0

### 1. Configuração de Credenciais
Para automatizar o processo e evitar prompts interativos, utilize o arquivo de variáveis locais:

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edite o arquivo terraform.tfvars com sua senha do banco
```

### 2. Implantação
```bash
terraform init
terraform plan
terraform apply
```

### 3. Acesso aos Recursos
**Acesso via SSM (Session Manager):**
```bash
aws ssm start-session --target <INSTANCE_ID>
```

### 4. Encerramento (Custo Zero)
```bash
terraform destroy
```

---

## Roadmap para Produção

Para evoluir esta arquitetura para ambientes críticos, recomenda-se:

- **Segurança:** Implementar AWS Secrets Manager, Criptografia at-rest (KMS) e WAF.
- **Infraestrutura:** Adicionar NAT Gateway, Application Load Balancer e Auto Scaling Groups.
- **Observabilidade:** Configurar CloudWatch Alarms, RDS Enhanced Monitoring e Logs centralizados.
- **Resiliência:** Habilitar RDS Multi-AZ e políticas de backup automatizado.
- **Operações:** Configurar Remote State (S3 + DynamoDB) e pipelines de CI/CD.

---
**Mantido por Rodolfo Martins**