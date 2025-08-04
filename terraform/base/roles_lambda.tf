# The lambda policy for its execution
resource "aws_iam_policy" "lambda_exec_policy_base" {
  name        = local.policy_lambda_base_name
  description = "The lambda policy for its execution"
  policy      = local.lambda_policy_base
}

# The lambda policy for accessing data (eg: dynamodb, s3 etc.)
resource "aws_iam_policy" "lambda_exec_policy_data" {
  name        = local.policy_lambda_data_name
  description = "The lambda exec policy for accessing data (eg: dynamodb, s3 etc.)"
  policy      = local.lambda_policy_data
}

# The lambda policy for accessing ai services (eg: Bedrock, OSS, etc.)
resource "aws_iam_policy" "lambda_exec_policy_ai" {
  name        = local.policy_lambda_ai_name
  description = "The lambda exec policy for accessing ai services (eg: Bedrock, OSS, etc.)"
  policy      = local.lambda_policy_ai
}

# The lambda policy for accessing secrets (eg: KMS, Parameter Store, etc.)
resource "aws_iam_policy" "lambda_exec_policy_secrets" {
  name        = local.policy_lambda_secret_name
  description = "The lambda policy for accessing secrets (eg: KMS, Parameter Store, etc.)"
  policy      = local.lambda_policy_secret
}

# The lambda policy for accessing monitoring services (eg: cloudwatch, xray , etc.)
resource "aws_iam_policy" "lambda_exec_policy_monitoring" {
  name        = local.policy_lambda_monitoring_name
  description = "The lambda policy for accessing monitoring services (eg: cloudwatch, xray , etc.)"
  policy      = local.lambda_policy_monitoring
}
