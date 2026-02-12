# --- SAÍDAS DO BANCO DE DADOS (OUTPUTS) ---

output "db_instance_endpoint" {
  description = "O endereço (endpoint) do banco de dados para conexão"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_name" {
  description = "O nome do banco de dados inicial"
  value       = aws_db_instance.main.db_name
}

output "db_instance_username" {
  description = "O usuário master do banco de dados"
  value       = aws_db_instance.main.username
}

output "db_instance_port" {
  description = "A porta na qual o banco de dados está ouvindo"
  value       = aws_db_instance.main.port
}

output "db_security_group_id" {
  description = "ID do Security Group do banco (útil para adicionar regras de entrada depois)"
  value       = aws_security_group.rds_sg.id
}
