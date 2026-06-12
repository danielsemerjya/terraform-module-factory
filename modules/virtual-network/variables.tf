variable "name" {
  type        = string
  description = "Name of the virtual network. 2-64 characters; alphanumerics, hyphens, underscores and periods; must start with a letter or number and end with a letter, number or underscore."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,62}[a-zA-Z0-9_]$", var.name))
    error_message = "name must be 2-64 chars, start with a letter or number, end with a letter, number or underscore, and contain only alphanumerics, '.', '_' and '-'."
  }
}

variable "location" {
  type        = string
  description = "Azure region where the virtual network is created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group the virtual network is deployed into."
}

variable "address_space" {
  type        = list(string)
  description = "CIDR ranges assigned to the virtual network, e.g. [\"10.0.0.0/16\"]. At least one is required."

  validation {
    condition     = length(var.address_space) > 0
    error_message = "address_space must contain at least one CIDR range."
  }

  validation {
    condition     = alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "every entry in address_space must be a valid CIDR range, e.g. \"10.0.0.0/16\"."
  }
}

variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS server IP addresses for the virtual network. Empty list (default) uses Azure-provided DNS."
  default     = []
}

variable "subnets" {
  type = map(object({
    address_prefixes                  = list(string)
    service_endpoints                 = optional(list(string), [])
    private_endpoint_network_policies = optional(string, "Disabled")
    default_outbound_access_enabled   = optional(bool, false)
    delegation = optional(object({
      name    = string
      service = string
      actions = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/action"])
    }), null)
  }))
  description = "Subnets keyed by subnet name. Secure defaults: private_endpoint_network_policies is Disabled (required for private endpoints) and default outbound internet access is off — provide a NAT gateway or explicit route for egress."
  default     = {}

  validation {
    condition     = alltrue([for s in values(var.subnets) : length(s.address_prefixes) > 0])
    error_message = "every subnet must define at least one address prefix."
  }

  validation {
    condition     = alltrue(flatten([for s in values(var.subnets) : [for cidr in s.address_prefixes : can(cidrhost(cidr, 0))]]))
    error_message = "every subnet address prefix must be a valid CIDR range."
  }

  validation {
    condition     = alltrue([for s in values(var.subnets) : contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], s.private_endpoint_network_policies)])
    error_message = "private_endpoint_network_policies must be one of: Disabled, Enabled, NetworkSecurityGroupEnabled, RouteTableEnabled."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the virtual network."
  default     = {}
}
