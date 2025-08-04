terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
#   backend "s3" {
#     access_key = ""
#     secret_key = ""
#     token      = ""
#     bucket     = ""
#     key        = ""
#     region     = ""
#   }
}

provider "aws" {

  #   access_key = var.aws_access_key
  #   secret_key = var.aws_secret_key
  region = var.aws_region
  #
  #   assume_role {
  #     role_arn = "arn:aws:iam::${var.aws_account_id}:role/uais_admin_access_role"
  #   }
}
