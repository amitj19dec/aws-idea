variable "tower_ips" {
    description = "Optum Tower IPs"
    type        = list(string)
}

variable "bucket_prefix" {
  description = "Name of Project"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
}

variable "kms_arn" {
  description = "kms key to encrypt EFS"
  type        = string
}

variable "sagemaker_role_arn" {
  description = "arn of sagemaker domain"
  type        = string
}
