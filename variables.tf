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