terraform {

  backend "s3" {
    bucket         = "terraform-state-2rspoo" # O nome do bucket que você criou
    key            = "database/terraform.tfstate"      # O caminho/nome do arquivo de estado dentro do bucket
    region         = "us-east-1"                       # A região do bucket
    # dynamodb_table = "terraform-state-lock"            # A tabela de travamento que você criou
  }
}