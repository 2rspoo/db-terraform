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
      version = "1.0.0" # Verifique a versão mais recente
    }
  }
}


