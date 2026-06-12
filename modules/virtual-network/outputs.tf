output "id" {
  description = "Resource ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "address_space" {
  description = "Address space of the virtual network."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Map of subnet name to subnet resource ID."
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnets" {
  description = "Map of subnet name to subnet attributes (id, address_prefixes)."
  value = {
    for k, s in azurerm_subnet.this : k => {
      id               = s.id
      address_prefixes = s.address_prefixes
    }
  }
}
