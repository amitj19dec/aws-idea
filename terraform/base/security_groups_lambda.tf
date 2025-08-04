resource "aws_security_group" "lambda_sg" {
  name        = "${local.base_prefix}-lambda-sg"
  description = "Security group for Lambda functions within project VPC"
  vpc_id      = module.spoke_vpc.vpc_attributes.id

  # Allow HTTPS outbound to OpenSearch
  egress {
    description = "HTTPS access to OpenSearch domain"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = true
  }

  # Allow HTTPS outbound to VPC endpoints
  egress {
    description = "HTTPS access to VPC endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.spoke_vpc.vpc_attributes.cidr_block]
  }

  # Allow all outbound for external service calls (Bedrock, etc.)
  egress {
    description = "Outbound access for external AWS services"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      name       = "${local.base_prefix}-lambda-sg"
    }
  )
}
