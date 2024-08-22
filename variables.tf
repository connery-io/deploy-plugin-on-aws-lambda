variable "plugin_name" {
  description = "Plugin name (e.g. connery-plugin-example)"
  type        = string
}

variable "plugin_version" {
  description = "Plugin version (e.g. v1)"
  type        = string
}

# Lambda function

variable "memory_size" {
  description = "Memory size"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout"
  type        = number
  default     = 30
}

# Custom policy

variable "attach_policy_statements" {
  description = "Controls whether policy_statements should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to Lambda Function role"
  type        = any
  default     = {}
}

# VPC deployment

variable "attach_network_policy" {
  description = "Controls whether VPC/network policy should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

# Custom environment variables

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

# Other

variable "resource_name_prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "connery-plugin"
}