variable "vpc_name" {
  type        = string
  description = "Name of the VPC where the EC2 instance(s) are created."
}

variable "vpc" {
  type        = any
  description = "VPC resources."
}

variable "vpc_cidr" {
  type        = any
  description = "VPC CIDR Block"
}

variable "endpoint_names" {
  type        = list(string)
  description = "VPC Endpoint Names"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
}
