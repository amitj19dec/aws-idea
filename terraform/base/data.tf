data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Sagemaker specific data blocks
data "aws_iam_policy" "bedrock_full_access" {
  name = "AmazonBedrockFullAccess"
}

data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  name = "AmazonSageMakerFullAccess"
}

data "aws_iam_policy" "AmazonSageMakerCanvasFullAccess" {
  name = "AmazonSageMakerCanvasFullAccess"
}

data "aws_iam_policy" "AmazonSageMakerCanvasAIServicesAccess" {
  name = "AmazonSageMakerCanvasAIServicesAccess"
}

data "aws_iam_policy_document" "sagemaker_domain_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# OpenSearch specific data blocks
data "aws_iam_policy_document" "opensearch_master_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
