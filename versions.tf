terraform {
  required_providers {
    # ... seus outros provedores (aws, etc)
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # Adicione este provedor para SQL genérico
    sql = {
      source  = "paultyng/sql"
      version = "~> 0.4.0" # <-- Use uma versão válida, como a 0.4.0
    }
  }
}


