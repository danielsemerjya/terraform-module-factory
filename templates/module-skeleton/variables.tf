# All variables live here (standards/variables-outputs.md): explicit type + description
# on every variable, a validation block on every constrained input, secure defaults
# (standards/azure-conventions.md).

variable "name" {
  type        = string
  description = "Name of the TODO. TODO: add Azure naming-rule validation — research the real limits (/research), don't guess."
}

variable "location" {
  type        = string
  description = "Azure region where the resources are created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group to deploy into."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all taggable resources created by this module."
  default     = {}
}
