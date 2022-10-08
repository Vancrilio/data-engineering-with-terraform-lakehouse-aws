##################################################################
# Declaração das Variáveis Terraform (IAC) Utilizadas no Projeto #
##################################################################

variable "region" {
  description = "aws region"
  default     = "us-east-1"                                  #Região do Norte da Virginia
}

variable "account_id" {
  default = 999999999999                                    #ID da Conta AWS (Substituir pelo ID AWS Real)             
}

variable "prefix" {
  description = "objects prefix"
  default     = "client-company-dl"                         #Nome da Empresa Cliente + DL (Data Lake)                                   
}


variable "profile" {
  description = "profile"
  default     = "api"                                       #Usuário AWS com acesso programático para gerenciamento da infraestrutura
}

# Configuração de prefixos e tags do projeto (Bucket de scripts do Glue)
locals {
  glue_bucket = "${var.prefix}-${var.bucket_names[4]}-${var.account_id}"
  prefix      = var.prefix
  common_tags = {
    Projeto = "datalake-client-company"
  }
}

# Nomes dos Buckets do Datalakehouse
variable "bucket_names" {
  description = "s3 bucket names"
  type        = list(string)
  default = [
    "landing-zone",
    "bronze",
    "silver",
    "gold",
    "aws-glue-scripts"
  ]

}
