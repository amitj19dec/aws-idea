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

data "aws_subnets" "opensearch_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${local.base_prefix}-endpoints*"]
  }
}

data "aws_iam_role" "opensearch_master_role" {
  name = local.opensearch_master_role_name
}

data "aws_security_group" "lambda_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.base_prefix}-lambda-sg"]
  }
  vpc_id = data.aws_vpc.spoke_vpc.id
}

data "aws_security_group" "sagemaker_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.base_prefix}-sagemaker-sg"]
  }
  vpc_id = data.aws_vpc.spoke_vpc.id
}
