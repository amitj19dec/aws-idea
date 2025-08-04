data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "spoke_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.base_prefix}-vpc"]
  }
}

data "aws_kms_key" "base_kms_key" {
  key_id = local.kms_key_alias
}

data "aws_subnets" "sagemaker_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${local.base_prefix}-sagemaker*"]
  }
}

data "aws_s3_bucket" "workspace_bucket" {
  bucket = "${local.base_prefix}-workspace-bucket"
}

data "aws_s3_bucket" "byod_bucket" {
  bucket = "${local.base_prefix}-byod-bucket"
}

data "aws_ecr_repository" "base_ecr" {
  name = "${local.base_prefix}-ecr"
}

data "aws_iam_role" "sagemaker_domain_default_execution_role" {
  name = local.sagemaker_role_name
}
