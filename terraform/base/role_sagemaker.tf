resource "aws_iam_role" "sagemaker_domain_default_execution_role" {
  name               = "${local.base_prefix}-sagemaker-domain-exec-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_domain_assume_role_policy.json
}

# Allows access to sagemaker s3 get, put and list
# Allows access to sagemaker ecr get, put,
# Allows only model training and block all model deployment activities
resource "aws_iam_policy" "sagemaker_execution_policy" {
  name        = local.sagemaker_policy_name
  description = "Policy to allow model training in SageMaker, access to specified S3 and ECR resources"
  policy      = local.sagemaker_policy
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = aws_iam_policy.sagemaker_execution_policy.arn
}

# Attaching the AmazonSageMakerFullAccess policy to the SageMaker execution role
# Model creation and deployment is blocked by the custom deny policy above
resource "aws_iam_role_policy_attachment" "attach_sagemaker_policy" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "attach_sagemaker_canvas_policy" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerCanvasFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "attach_sagemaker_canvas_services_policy" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerCanvasAIServicesAccess.arn
}

resource "aws_iam_role_policy_attachment" "attach_bedrock_policy" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = data.aws_iam_policy.bedrock_full_access.arn
}
