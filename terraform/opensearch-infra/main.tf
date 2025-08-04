resource "aws_security_group" "opensearch_sg" {
  name        = "${local.base_prefix}-opensearch-sg"
  description = "Security group for OpenSearch domain within project VPC"
  vpc_id      = data.aws_vpc.spoke_vpc.id

  # Allow HTTPS access from Lambda security group
  ingress {
    description     = "HTTPS access from Lambda functions"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [data.aws_security_group.lambda_sg.id]
  }

  # Allow HTTPS access from SageMaker security group
  ingress {
    description     = "HTTPS access from SageMaker domain"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [data.aws_security_group.sagemaker_sg.id]
  }

  # No explicit egress rules - AWS default deny all outbound

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      name       = "${local.base_prefix}-opensearch-sg"
    }
  )
}

resource "aws_opensearch_domain" "opensearch" {
  domain_name    = "${local.base_prefix}-opensearch"
  engine_version = var.engine_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master_enabled
    master_instance_type     = var.master_instance_type
    master_instance_count    = var.master_instance_count
    zone_awareness_enabled   = var.zone_awareness_enabled

    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_enabled ? [1] : []
      content {
        availability_zone_count = length(data.aws_subnets.opensearch_subnets.ids)
      }
    }
  }

  # VPC configuration for private deployment
  vpc_options {
    subnet_ids         = data.aws_subnets.opensearch_subnets.ids
    security_group_ids = [aws_security_group.opensearch_sg.id]
  }

  # EBS storage configuration
  ebs_options {
    ebs_enabled = true
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
  }

  # Fine-grained access control with IAM master user
  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = false
    master_user_options {
      master_user_arn = data.aws_iam_role.opensearch_master_role.arn
    }
  }

  # Encryption at rest using project-scoped KMS key
  encrypt_at_rest {
    enabled    = true
    kms_key_id = data.aws_kms_key.base_kms_key.arn
  }

  # Node-to-node encryption
  node_to_node_encryption {
    enabled = true
  }

  # Domain endpoint options
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  # Log publishing configuration
  log_publishing_options {
    enabled                  = true
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_slow_logs.arn
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_app_logs.arn
  }

  log_publishing_options {
    enabled                  = true
    log_type                 = "AUDIT_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_audit_logs.arn
  }

  # Access policy restricting to project VPC
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.opensearch_master_role.arn
        }
        Action   = "es:*"
        Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.base_prefix}-opensearch/*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      name       = "${local.base_prefix}-opensearch"
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.opensearch_slow_logs,
    aws_cloudwatch_log_group.opensearch_app_logs,
    aws_cloudwatch_log_group.opensearch_audit_logs
  ]
}

# CloudWatch log groups for OpenSearch logs
resource "aws_cloudwatch_log_group" "opensearch_slow_logs" {
  name              = "/aws/opensearch/domains/${local.base_prefix}-opensearch/search-slow-logs"
  retention_in_days = 30
  kms_key_id        = data.aws_kms_key.base_kms_key.arn

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_cloudwatch_log_group" "opensearch_app_logs" {
  name              = "/aws/opensearch/domains/${local.base_prefix}-opensearch/application-logs"
  retention_in_days = 30
  kms_key_id        = data.aws_kms_key.base_kms_key.arn

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_cloudwatch_log_group" "opensearch_audit_logs" {
  name              = "/aws/opensearch/domains/${local.base_prefix}-opensearch/audit-logs"
  retention_in_days = 90
  kms_key_id        = data.aws_kms_key.base_kms_key.arn

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

# Parameter Store for service discovery
resource "aws_ssm_parameter" "opensearch_endpoint" {
  name  = "/params/${local.base_prefix}/platform/opensearch-endpoint"
  type  = "String"
  value = aws_opensearch_domain.opensearch.endpoint

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_ssm_parameter" "opensearch_domain_arn" {
  name  = "/params/${local.base_prefix}/platform/opensearch-domain-arn"
  type  = "String"
  value = aws_opensearch_domain.opensearch.arn

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_ssm_parameter" "opensearch_kibana_endpoint" {
  name  = "/params/${local.base_prefix}/platform/opensearch-dashboards-endpoint"
  type  = "String"
  value = aws_opensearch_domain.opensearch.kibana_endpoint

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}
