variable "aws_region" {
  description = "Região AWS onde os recursos são criados."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nome do ambiente (homolog ou production)."
  type        = string

  validation {
    condition     = contains(["homolog", "production"], var.environment)
    error_message = "O ambiente deve ser 'homolog' ou 'production'."
  }
}

variable "db_name" {
  description = "Nome do database criado na instância."
  type        = string
  default     = "oficina"
}

variable "db_username" {
  description = "Usuário administrador do PostgreSQL."
  type        = string
  default     = "oficina_admin"
}

variable "db_password" {
  description = "Senha do usuário administrador. Fornecida via TF_VAR_db_password (secret DB_PASSWORD), nunca versionada."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "A senha do banco deve ter pelo menos 8 caracteres."
  }
}

variable "db_instance_class" {
  description = "Classe da instância RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento inicial em GiB."
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Limite para o autoscaling de armazenamento em GiB (0 desabilita)."
  type        = number
  default     = 40
}

variable "db_engine_version" {
  description = "Versão major do PostgreSQL."
  type        = string
  default     = "16"
}

variable "multi_az" {
  description = "Habilita Multi-AZ (mais caro; mantido desabilitado por padrão para reduzir custo)."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Dias de retenção dos backups automáticos."
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Protege a instância contra remoção acidental."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Não gera snapshot final ao destruir a instância."
  type        = bool
  default     = true
}
