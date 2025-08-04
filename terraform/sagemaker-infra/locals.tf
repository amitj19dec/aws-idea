locals {
  optum_ip_whitelist = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23",
  "198.203.176.0/22", "198.203.180.0/23"]
  resource_provisioner = "UAIS"
  base_prefix          = "uais-${split("-", var.project_id)[0]}"
  kms_key_alias        = "alias/${local.base_prefix}-kms-key"
  sagemaker_role_name  = "${local.base_prefix}-sagemaker-domain-exec-role"
}
