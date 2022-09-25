##################################################################
# Declaração das Variáveis Terraform (IAC) Utilizadas no Projeto #
##################################################################

variable "region" {
  description = "aws region"
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}

