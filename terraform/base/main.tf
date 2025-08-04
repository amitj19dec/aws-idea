# Creates a vpc with subnets, route tables for the workspace.
# Adds a tag np_ready_to_reroute to true for HCP scheduler to reroute traffic to firewall by adding a route to the route tables created.
module "spoke_vpc" {
  source     = "aws-ia/vpc/aws"
  version    = "= 4.4.4"
  name       = "${local.base_prefix}-vpc"
  cidr_block = var.vpc.cidr_block
  az_count   = var.vpc.number_azs
  subnets = {
    sagemaker_subnet = {
      name_prefix = "${local.base_prefix}-sagemaker"
      cidrs       = var.vpc.sagemaker_subnet_cidrs
    }

    endpoints_subnet = {
      name_prefix = "${local.base_prefix}-endpoints"
      cidrs       = var.vpc.endpoint_subnet_cidrs
    }
  }
  tags = merge(
    var.tags,
    {
      provisoner          = local.resource_provisioner
      name                = "${local.base_prefix}-vpc"
      np_ready_to_reroute = "true"
    }
  )
}

# Kms key which will be used for SSE encryption resources in this workspace.
resource "aws_kms_key" "base_kms_key" {
  description         = "KMS key used to encrypt S3 and workspace resources"
  enable_key_rotation = true
}

resource "aws_kms_alias" "my_key_alias" {
  name          = local.kms_key_alias
  target_key_id = aws_kms_key.base_kms_key.key_id
}

resource "aws_kms_key_policy" "base_kms_key_policy" {
  key_id = aws_kms_key.base_kms_key.id
  policy = jsonencode({
    Id = "base_worksapce_key_policy"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = [
            data.aws_caller_identity.current.account_id
          ]
        }
        Resource = "*"
        Sid      = "Enable all IAM role/user in this account to use this key"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_ecr_repository" "base_ecr_repository" {
  name                 = "${local.base_prefix}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      name       = "${local.base_prefix}-ecr"
    }
  )
}

# Creates all s3 buckets required for this workspace.
module "s3_bucket" {
  source             = "./s3_bucket"
  bucket_prefix      = local.base_prefix
  kms_arn            = aws_kms_key.base_kms_key.arn
  tower_ips          = local.optum_ip_whitelist
  sagemaker_role_arn = aws_iam_role.sagemaker_domain_default_execution_role.arn
  tags               = merge(var.tags, { provisoner = local.resource_provisioner })
}

# Creates all VPC endpoints to the endpoint_names as input required for this workspace.
# Interface endpoints are created for passed services names.
# Gateway endpoint is created for S3.
module "vpc_endpoints" {
  source         = "./endpoints"
  vpc_name       = "${local.base_prefix}-vpc"
  vpc            = module.spoke_vpc
  vpc_cidr       = module.spoke_vpc.vpc_attributes.cidr_block
  endpoint_names = var.endpoint_names
  tags           = merge(var.tags, { provisoner = local.resource_provisioner })
}
