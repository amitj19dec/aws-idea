locals {
  optum_ip_whitelist = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23",
  "198.203.176.0/22", "198.203.180.0/23"]
  resource_provisioner = "UAIS"
  base_prefix          = "uais-${split("-", var.project_id)[0]}"
  kms_key_alias        = "alias/${local.base_prefix}-kms-key"

  # Generic Policy locals
  policy_template_path = "${path.module}/policies"
  policy_arn_prefix = "arn:aws:%s:${var.aws_region}:${var.aws_account_id}"

  # Lambda Policy locals

  policy_lambda_template_path = "${local.policy_template_path}/lambda"

  policy_lambda_base_name = "${local.base_prefix}-lambda-base-policy"
  policy_lambda_data_name = "${local.base_prefix}-lambda-data-storage-policy"
  policy_lambda_ai_name = "${local.base_prefix}-lambda-ai-services-policy"
  policy_lambda_secret_name = "${local.base_prefix}-lambda-secret-config-policy"
  policy_lambda_monitoring_name = "${local.base_prefix}-lambda-monitoring-policy"

  policy_lambda_arn_ssm = format("${local.policy_arn_prefix}:parameter/params/lambda/${local.base_prefix}*", "ssm") # Eg: arn:aws:ssm:us-east-1:952189540345:parameter/params/lambda/uais-c6945420*
  policy_lambda_arn_dynamodb = format("${local.policy_arn_prefix}:table/${local.base_prefix}-dynamodb*", "dynamodb") # Eg: arn:aws:dynamodb:us-east-1:952189540345:table/uais-b4854dd4-dynamodb*

  lambda_policy_base = templatefile("${local.policy_lambda_template_path}/base.json.tpl", {})

  lambda_policy_data = templatefile("${local.policy_lambda_template_path}/data.json.tpl", {
    dynamodb_resource_arn = local.policy_lambda_arn_dynamodb
  })

  lambda_policy_secret = templatefile("${local.policy_lambda_template_path}/secret.json.tpl", {
    param_store_resource_arn = local.policy_lambda_arn_ssm
  })

  lambda_policy_ai = templatefile("${local.policy_lambda_template_path}/ai.json.tpl", {
    param_store_resource_arn  = local.policy_lambda_arn_ssm
    opensearch_domain_arn     = local.opensearch_domain_arn
    opensearch_master_role_arn = "arn:aws:iam::${var.aws_account_id}:role/${local.base_prefix}-opensearch-master-role"
  })

  lambda_policy_monitoring = templatefile("${local.policy_lambda_template_path}/monitoring.json.tpl", {
    param_store_resource_arn = local.policy_lambda_arn_ssm
  })

  sagemaker_policy_name = "${local.base_prefix}-sagemaker-execution-policy"
  sagemaker_policy = templatefile("${path.module}/policies/sagemaker/sagemaker_custom.tpl", {
    workspace_bucket_arn = module.s3_bucket.workspace_bucket_arn
    byod_bucket_arn      = module.s3_bucket.byod_bucket_arn
    base_ecr_arn         = aws_ecr_repository.base_ecr_repository.arn
    sagemaker_role_arn   = aws_iam_role.sagemaker_domain_default_execution_role.arn
    base_kms_arn         = aws_kms_key.base_kms_key.arn
  })

  # OpenSearch Policy locals
  opensearch_policy_name = "${local.base_prefix}-opensearch-master-policy"
  opensearch_domain_arn = format("${local.policy_arn_prefix}:domain/${local.base_prefix}-opensearch/*", "es")
  opensearch_master_policy = templatefile("${path.module}/policies/opensearch/opensearch_master.tpl", {
    opensearch_domain_arn = local.opensearch_domain_arn
    base_kms_arn         = aws_kms_key.base_kms_key.arn
  })
}
