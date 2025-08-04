variable "aws_region" {
  description = "AWS Region."
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "UAIS Project ID tied to the workspace"
  type        = string
}

variable "vpc" {
  description = "Base workspace VPC definition."
  type        = any
}

variable "endpoint_names" {
  type        = list(string)
  description = "List of VPC Endpoints Names to deploy"

  default = ["sagemaker.api", "sagemaker.runtime", "sagemaker.featurestore-runtime", "sts", "ecr.dkr", "ecr.api"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}
