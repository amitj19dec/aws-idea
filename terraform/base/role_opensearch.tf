resource "aws_iam_role" "opensearch_master_role" {
  name               = "${local.base_prefix}-opensearch-master-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.opensearch_master_assume_role_policy.json

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

# Minimal IAM policy for OpenSearch master role (authentication only)
# Fine-grained access control handles authorization within OpenSearch
resource "aws_iam_policy" "opensearch_master_policy" {
  name        = local.opensearch_policy_name
  description = "Minimal policy for OpenSearch master role authentication"
  policy      = local.opensearch_master_policy

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_iam_role_policy_attachment" "attach_opensearch_master_policy" {
  role       = aws_iam_role.opensearch_master_role.name
  policy_arn = aws_iam_policy.opensearch_master_policy.arn
}

# Allow Lambda execution role to assume OpenSearch master role for API access
resource "aws_iam_policy" "lambda_opensearch_assume_policy" {
  name        = "${local.base_prefix}-lambda-opensearch-assume-policy"
  description = "Allow Lambda execution role to assume OpenSearch master role"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.opensearch_master_role.arn
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}
