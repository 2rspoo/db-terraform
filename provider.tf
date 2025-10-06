terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" // Ou sua região de preferência
}

provider "sql" {
  # Informa que estamos usando o driver do PostgreSQL
  driver = "postgres"

  # Monta a string de conexão usando os dados do recurso RDS que você criou.
  # O Terraform preenche isso automaticamente depois que o banco fica pronto.
  data_source_name = "postgres://${aws_db_instance.main_db.username}:${aws_db_instance.main_db.password}@${aws_db_instance.main_db.address}:${aws_db_instance.main_db.port}/${aws_db_instance.main_db.db_name}?sslmode=require"
}