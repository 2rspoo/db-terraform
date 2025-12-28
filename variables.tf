variable "db_username" {
  description = "Usuário mestre do banco de dados"
  type        = string
}

variable "db_password" {
  description = "Senha mestre do banco de dados"
  type        = string
  sensitive   = true # Oculta a senha nos logs do terminal
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