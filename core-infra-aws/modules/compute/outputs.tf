# --- SAÍDAS DA COMPUTAÇÃO (OUTPUTS) ---

output "instance_id" {
  description = "ID da instância EC2 criada"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Endereço IP público da instância"
  value       = aws_instance.app_server.public_ip
}

output "security_group_id" {
  description = "ID do Security Group da instância"
  value       = aws_security_group.compute_sg.id
}
