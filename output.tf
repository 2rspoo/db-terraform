output "db_endpoints" {
  description = "Endpoints dos bancos de dados PostgreSQL"
  value = {
    for service, instance in aws_db_instance.postgres_db : service => instance.endpoint
  }
}

output "dynamodb_table_name" {
  description = "Nome da tabela do DynamoDB para Pedidos"
  value       = aws_dynamodb_table.pedidos_db.name
}
