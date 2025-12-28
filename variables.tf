variable "db_password" {
  description = "Senha para o banco de dados RDS"
  type        = string
  sensitive   = true // Marca a variável como sensível para não ser exibida nos logs
}

variable "db_username" {
  description = "Usuário master para o banco de dados"
  type        = string
  default     = "postgresadmin"
}

variable "postgres_services" {
  type = map(object({
    db_name = string
  }))
  default = {
    "clientes" = { db_name = "clientes_db" },
    "produtos" = { db_name = "produtos_db" }
  }
}