resource "aws_security_group" "sagemaker_sg" {
  name        = "${local.base_prefix}-sagemaker-sg"
  description = "Allow certain NFS and TCP inbound traffic"
  vpc_id      = data.aws_vpc.spoke_vpc.id

  # restricting access from optum tower ips
  ingress {
    description = "Ingress access only with in optum tower ips"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.optum_ip_whitelist
  }

  ingress {
    description = "NFS traffic over TCP on port 2049 between the domain and EFS volume"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "TCP traffic between JupyterServer app and the KernelGateway apps"
    from_port   = 8192
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # By default, AWS creates an ALLOW ALL egress rule when creating a new Security Group inside of a VPC.
  # When creating a new Security Group inside a VPC, Terraform will remove this default rule,
  # and require you specifically re-create it if you desire that rule.
  egress {
    description      = "Allow outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # semantically equivalent to all ports
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      name       = "${local.base_prefix}-sagemaker-sg"
    }
  )
}

resource "aws_sagemaker_domain" "sagemaker_domain" {
  domain_name             = "${local.base_prefix}-sagemaker-domain"
  app_network_access_type = var.app_network_access_type
  auth_mode               = var.auth_mode
  vpc_id                  = data.aws_vpc.spoke_vpc.id
  subnet_ids              = data.aws_subnets.sagemaker_subnets.ids
  kms_key_id              = data.aws_kms_key.base_kms_key.arn

  default_space_settings {
    execution_role = data.aws_iam_role.sagemaker_domain_default_execution_role.arn
  }

  default_user_settings {
    execution_role    = data.aws_iam_role.sagemaker_domain_default_execution_role.arn
    studio_web_portal = "ENABLED"
    sharing_settings {
      notebook_output_option = "Allowed"
      s3_kms_key_id          = data.aws_kms_key.base_kms_key.arn
      s3_output_path         = "s3://${data.aws_s3_bucket.workspace_bucket.id}/shared-notebooks"
    }
  }

  domain_settings {
    security_group_ids = [aws_security_group.sagemaker_sg.id]
  }

  retention_policy {
    home_efs_file_system = "Retain"
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      name       = "${local.base_prefix}-sagemaker-domain"
    }
  )
}

resource "aws_sagemaker_user_profile" "default_user" {
  for_each = toset(var.user_profile_names)

  domain_id         = aws_sagemaker_domain.sagemaker_domain.id
  user_profile_name = each.value

  user_settings {
    execution_role  = data.aws_iam_role.sagemaker_domain_default_execution_role.arn
    security_groups = [aws_security_group.sagemaker_sg.id]
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      username   = each.value
    }
  )
}
