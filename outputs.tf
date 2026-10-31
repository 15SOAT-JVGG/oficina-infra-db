output "db_endpoint" {
  description = "Endpoint (host:porta) do PostgreSQL."
  value       = aws_db_instance.database.endpoint
}

output "db_identifier" {
  description = "Identificador do RDS, usado para consultar as métricas nativas no CloudWatch."
  value       = aws_db_instance.database.identifier
}

output "db_address" {
  description = "Host do PostgreSQL."
  value       = aws_db_instance.database.address
}

output "db_port" {
  description = "Porta do PostgreSQL."
  value       = aws_db_instance.database.port
}

output "db_name" {
  description = "Nome do database."
  value       = aws_db_instance.database.db_name
}

output "db_username" {
  description = "Usuário administrador."
  value       = aws_db_instance.database.username
}

output "jdbc_url" {
  description = "URL JDBC para a aplicação Quarkus."
  value       = "jdbc:postgresql://${aws_db_instance.database.endpoint}/${aws_db_instance.database.db_name}"
}

output "reactive_url" {
  description = "URL do cliente reativo (Hibernate Reactive) para a aplicação Quarkus."
  value       = "postgresql://${aws_db_instance.database.endpoint}/${aws_db_instance.database.db_name}"
}

output "vpc_id" {
  description = "VPC onde o banco foi criado (consumida por oficina-infra-k8s e oficina-lambda-auth)."
  value       = data.aws_vpc.default.id
}

output "vpc_cidr_block" {
  description = "CIDR da VPC."
  value       = data.aws_vpc.default.cidr_block
}

output "subnet_ids" {
  description = "Subnets do DB subnet group."
  value       = data.aws_subnets.default.ids
}

output "security_group_id" {
  description = "Security group do banco."
  value       = aws_security_group.database.id
}
