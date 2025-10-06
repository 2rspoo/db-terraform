

provider "aws" {
  region = "us-east-1" // Ou sua região de preferência
}



provider "sql" {
  # O provedor agora usa um único argumento "url" com a string de conexão completa
  url = "postgres://${aws_db_instance.main_db.username}:${aws_db_instance.main_db.password}@${aws_db_instance.main_db.address}:${aws_db_instance.main_db.port}/${aws_db_instance.main_db.db_name}?sslmode=require"
}