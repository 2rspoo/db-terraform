terraform {
  required_providers {
    # ... seus outros provedores (aws, etc)
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }


  }
}


