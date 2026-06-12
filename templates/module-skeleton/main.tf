# Resources live here. The primary resource is labeled `this` (standards/naming.md).
# Split into concern-named files (network.tf, diagnostics.tf, ...) only when this file
# exceeds ~150 lines (standards/module-structure.md).
#
# Before writing any resource: verify its schema with the provider-researcher agent.

# resource "azurerm_TODO" "this" {
#   name                = var.name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags
# }
