output "db_endpoint" {
  description = "O endereço de conexão para a instância do banco de dados"
  value       = aws_db_instance.main_db.endpoint
}