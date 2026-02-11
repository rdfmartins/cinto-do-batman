# Documentação Técnica: Implementação de Rede (VPC) com Terraform

**Data:** 11/02/2026
**Projeto:** Cinto Batman AWS (Infraestrutura Modular)
**Objetivo:** Transição de conhecimento prático (Console AWS) para Infrastructure as Code (IaC).

## 1. Estratégia de IaC (Infrastructure as Code)

A decisão de migrar para Terraform visa atender a requisitos de mercado focados em **Automação**, **Escalabilidade** e **Governança**.

*   **O Console (ClickOps):** Serve para prototipagem e entendimento visual dos recursos.
*   **Terraform:** Habilita a construção de infraestrutura reproduzível, versionada (Git) e auditável. Transforma o Arquiteto em alguém que desenha "plantas" (blueprints) ao invés de assentar tijolos manualmente.

## 2. Arquitetura Modular

Adotamos uma estrutura de diretórios baseada em **Desacoplamento de Responsabilidades**:

```text
├── modules/
│   ├── network/       # Responsável pela topologia de rede (VPC, Subnets, Routing)
│   ├── database/      # Camada de persistência (RDS)
│   └── compute/       # Camada de processamento (EC2, ASG)
└── environments/
    └── dev/           # Consumidor dos módulos (Injeção de valores específicos)
```

## 3. Implementação do Módulo de Rede (`modules/network`)

### Componente: VPC (Virtual Private Cloud)

O recurso `aws_vpc` é a fundação isolada da nossa rede na nuvem.

#### Código (`main.tf`)
```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
```

### Defesa Técnica (Pontos para Oratória/Entrevista)

1.  **Parametrização do CIDR (`var.vpc_cidr`):**
    *   *Conceito:* Não "chumbamos" (hardcode) o IP `10.0.0.0/16`.
    *   *Justificativa:* Garante **Reusabilidade**. O mesmo código pode criar a rede de Produção e a de Desenvolvimento, apenas mudando o parâmetro de entrada. Evita sobreposição de IPs (IP Overlap) se precisarmos fazer Peering no futuro.

2.  **DNS Support & Hostnames (`true`):**
    *   *Conceito:* Habilita a resolução de nomes dentro da VPC.
    *   *Justificativa:* Facilita o **Service Discovery** (descoberta de serviços). As instâncias podem se comunicar via nomes DNS internos da AWS, que são mais estáveis que IPs privados em ambientes dinâmicos.

3.  **Tagging Dinâmico (`${var.project_name}-vpc`):**
    *   *Conceito:* Uso de interpolação de strings para nomear recursos.
    *   *Justificativa:* **Governança e FinOps**. Permite rastrear custos por projeto e facilita a auditoria e automação de scripts que filtram recursos por Tags.

4.  **Outputs (Exportação de Dados):**
    *   *Conceito:* O arquivo `outputs.tf` expõe o `vpc_id`.
    *   *Justificativa:* **Injeção de Dependência**. Módulos futuros (como o Security Group no módulo Compute) precisarão saber em qual VPC devem ser criados. O output é a "interface pública" do nosso módulo de rede.

## Próximos Passos (Backlog)
- [ ] Implementação de Subnets Públicas e Privadas (Conceito de Tiering).
- [ ] Internet Gateway (IGW) para saída pública.
- [ ] Route Tables para direcionamento de tráfego.
