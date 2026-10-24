locals {
  name = "oficina-${var.environment}"
}

# O Learner Lab não permite criar redes customizadas com facilidade; usamos a VPC padrão,
# que é compartilhada com o cluster EKS (repo oficina-infra-k8s) e com a Lambda de autenticação.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "database" {
  name        = "${local.name}-db"
  description = "Acesso PostgreSQL ao banco da oficina (${var.environment})"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${local.name}-db"
  }
}

# Somente recursos dentro da VPC (pods do EKS e Lambda) alcançam o banco.
resource "aws_vpc_security_group_ingress_rule" "postgres_from_vpc" {
  security_group_id = aws_security_group.database.id
  description       = "PostgreSQL a partir da VPC"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

resource "aws_db_subnet_group" "database" {
  name       = local.name
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = local.name
  }
}

resource "aws_db_instance" "database" {
  identifier = local.name

  engine         = "postgres"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage > 0 ? var.db_max_allocated_storage : null
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  backup_retention_period    = var.backup_retention_period
  auto_minor_version_upgrade = true
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${local.name}-final"

  tags = {
    Name = local.name
  }
}
