variable "aws_region" {
  description = "AWS Region."
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "UAIS Project ID tied to the workspace"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "auth_mode" {
  description = "The mode of authentication that members use to access the domain. Valid values are IAM and SSO"
  type        = string
  default     = "IAM"
}

variable "app_network_access_type" {
  description = "The network access type for the App domain. Valid values are PublicInternetOnly and VpcOnly"
  type        = string
  default     = "VpcOnly"
}

variable "user_profile_names" {
  type    = list(string)
  default = ["defaultuser"] # Replace with your actual list of user profile names
}

variable "enable_bedrock_access" {
  description = "Enable Bedrock access for the Sagemaker domain"
  type        = bool
  default     = false
}
