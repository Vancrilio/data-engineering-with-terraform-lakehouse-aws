terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"                   #Configurando para utilização da Versão 4.0 do Terraform
    }
  }
}

# Configuração do AWS Provider
provider "aws" {
  region  = var.region
  profile = var.profile
}

# Criação dos Buckets do Datalakehouse
resource "aws_s3_bucket" "buckets" {
  count  = length(var.bucket_names)
  bucket = "${var.prefix}-${var.bucket_names[count.index]}-${var.account_id}"

  force_destroy = true                     #Deixar True em período de teste até a entrada de produção - Força a Destroição dos Buckets até mesmo contendo arquivos.   
  tags          = local.common_tags
}

# Aplicação de Criptografia nos Buckets do Datalakehouse
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse" {
  count  = length(var.bucket_names)
  bucket = "${var.prefix}-${var.bucket_names[count.index]}-${var.account_id}"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  } 

  depends_on = [
    aws_s3_bucket.buckets               #Relação de Dependência: Aplicar a criptografia após criação dos Buckets
  ]

}

# Aplicação de Segurança ACL nos Buckets Privados do Datalakehouse
resource "aws_s3_bucket_acl" "bucket_acl" {
  count  = length(var.bucket_names)
  bucket = "${var.prefix}-${var.bucket_names[count.index]}-${var.account_id}"
  acl    = "private"                   #Buckets Privados

  depends_on = [
    aws_s3_bucket.buckets              #Relação de Dependência: Aplicar a segurança após criação dos Buckets
  ]
 
}

# Configuração de Segurança para Acesso Publico
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  count  = length(var.bucket_names)
  bucket = "${var.prefix}-${var.bucket_names[count.index]}-${var.account_id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.buckets            #Relação de Dependência: Aplicar a segurança após criação dos Buckets
  ]

}