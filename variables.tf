variable "plugin_name" {
  description = "Plugin name (e.g. connery-plugin-example)"
  type        = string
}

variable "plugin_version" {
  description = "Plugin version (e.g. v1)"
  type        = string
}

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

variable "resource_name_prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "connery-plugin"
}

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