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

variable "instance_type" {
  description = "Instance type for OpenSearch data nodes"
  type        = string
  default     = "m6g.large.search"
}

variable "instance_count" {
  description = "Number of data nodes in the OpenSearch domain"
  type        = number
  default     = 2
}

variable "dedicated_master_enabled" {
  description = "Enable dedicated master nodes"
  type        = bool
  default     = true
}

variable "master_instance_type" {
  description = "Instance type for OpenSearch master nodes"
  type        = string
  default     = "m6g.medium.search"
}

variable "master_instance_count" {
  description = "Number of dedicated master nodes"
  type        = number
  default     = 3
}

variable "ebs_volume_size" {
  description = "EBS volume size for OpenSearch nodes (GB)"
  type        = number
  default     = 100
}

variable "ebs_volume_type" {
  description = "EBS volume type for OpenSearch nodes"
  type        = string
  default     = "gp3"
}

variable "engine_version" {
  description = "OpenSearch engine version"
  type        = string
  default     = "OpenSearch_2.13"
}

variable "zone_awareness_enabled" {
  description = "Enable zone awareness for multi-AZ deployment"
  type        = bool
  default     = true
}
