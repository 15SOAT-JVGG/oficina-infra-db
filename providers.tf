terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }

  # Configuração parcial: bucket, key e region são informados no `terraform init`
  # via -backend-config (ver README e .github/workflows/terraform.yml).
  # O lock usa arquivo no próprio S3, dispensando a tabela DynamoDB (indisponível/opcional no Learner Lab).
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "oficina-mecanica"
      Repository  = "oficina-infra-db"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
