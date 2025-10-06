terraform {
  required_providers {
    # ... seus outros provedores (aws, etc)

    # Adicione este provedor para SQL genérico
    sql = {
      source  = "paultyng/sql"
      version = "1.0.0" # Verifique a versão mais recente
    }
  }
}