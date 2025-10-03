# 1. Cria uma VPC para isolar o banco de dados
resource "aws_vpc" "db_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "db-vpc"
  }
}

# 2. Cria subnets em diferentes zonas de disponibilidade para alta disponibilidade
resource "aws_subnet" "db_subnet_a" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "db-subnet-a"
  }
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "db-subnet-b"
  }
}

# 3. Agrupa as subnets para o RDS usar
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]
  tags = {
    Name = "Main DB Subnet Group"
  }
}

# 4. Cria um Security Group para controlar o acesso
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Permite acesso na porta do PostgreSQL"
  vpc_id      = aws_vpc.db_vpc.id

  # Libera acesso de entrada na porta 5432 (PostgreSQL) a partir de qualquer IP
  # ATENÇÃO: Em produção, restrinja o cidr_blocks para IPs conhecidos (ex: da sua aplicação)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Finalmente, cria a instância do banco de dados RDS
resource "aws_db_instance" "main_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.8"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password // Vem do GitHub Secrets
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
  publicly_accessible  = false // Mantenha como 'false' em produção
}