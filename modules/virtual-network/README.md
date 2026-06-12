# virtual-network

Manages an Azure Virtual Network and its subnets. Opinionated decisions: subnets are
private-endpoint-ready (`private_endpoint_network_policies = "Disabled"`) and have
default outbound internet access disabled — egress is explicit via NAT gateway or
routing. The module deploys into an existing resource group and does not invent
resource names; naming policy belongs to the caller.

## Usage

See [examples/basic](examples/basic) for minimal usage and
[examples/complete](examples/complete) for every feature (subnets with service
endpoints, delegation, custom DNS, tags).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.9 |
| azurerm | ~> 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| address\_space | CIDR ranges assigned to the virtual network, e.g. ["10.0.0.0/16"]. At least one is required. | `list(string)` | n/a | yes |
| location | Azure region where the virtual network is created. | `string` | n/a | yes |
| name | Name of the virtual network. 2-64 characters; alphanumerics, hyphens, underscores and periods; must start with a letter or number and end with a letter, number or underscore. | `string` | n/a | yes |
| resource\_group\_name | Name of the existing resource group the virtual network is deployed into. | `string` | n/a | yes |
| dns\_servers | Custom DNS server IP addresses for the virtual network. Empty list (default) uses Azure-provided DNS. | `list(string)` | `[]` | no |
| subnets | Subnets keyed by subnet name. Secure defaults: private\_endpoint\_network\_policies is Disabled (required for private endpoints) and default outbound internet access is off — provide a NAT gateway or explicit route for egress. | ```map(object({ address_prefixes = list(string) service_endpoints = optional(list(string), []) private_endpoint_network_policies = optional(string, "Disabled") default_outbound_access_enabled = optional(bool, false) delegation = optional(object({ name = string service = string actions = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/action"]) }), null) }))``` | `{}` | no |
| tags | Tags applied to the virtual network. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| address\_space | Address space of the virtual network. |
| id | Resource ID of the virtual network. |
| name | Name of the virtual network. |
| subnet\_ids | Map of subnet name to subnet resource ID. |
| subnets | Map of subnet name to subnet attributes (id, address\_prefixes). |
<!-- END_TF_DOCS -->
