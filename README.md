# AWS Infrastructure Repository (Cinto do Batman)

Este repositório centraliza projetos de **Infraestrutura como Código (IaC)**, automação de **DevOps** e padrões de arquitetura corporativa para AWS.

A organização segue o modelo de **Monorepo**, onde cada diretório contém uma solução independente, documentada e pronta para produção.

---

## 🔹 Projeto em Destaque

### [Core Infra AWS](./core-infra-aws)
**A Fundação Sólida para Ambientes Cloud Native.**

Este não é apenas um script de infraestrutura, é um framework completo de engenharia de plataforma que implementa:

*   **Zero Trust Security:** Acesso a servidores via AWS Systems Manager (SSM) sem portas SSH abertas.
*   **Arquitetura Modular:** Separação estrita de responsabilidades entre Rede, Dados e Computação.
*   **FinOps-Ready:** Ambientes efêmeros com destruição limpa e uso de recursos otimizados.
*   **Qualidade Automatizada:** Script de `bootstrap` que instala dependências e aplica Análise Estática de Código (AST com TFLint).

**Stack Tecnológica:** Terraform, AWS VPC, RDS (Postgres), EC2, IAM Roles.

---

## 📂 Outros Projetos
*(Novas ferramentas serão adicionadas aqui conforme o arsenal cresce)*

## 🛠️ Utilização Geral
Para utilizar qualquer recurso deste repositório, navegue até o diretório do projeto desejado. Cada projeto possui seu próprio script de inicialização (`bootstrap.sh`) e documentação detalhada.

```bash
# Exemplo: Iniciando o Core Infra
cd core-infra-aws
./bootstrap.sh
```

---
**Mantido por Rodolfo Martins**


*Arquitetura de Soluções & Engenharia de Cloud*
