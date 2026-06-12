provider "azurerm" {
  features {}
}

module "virtual_network" {
  source = "../.."

  name                = "vnet-example-prod-weu-001"
  location            = "westeurope"
  resource_group_name = "rg-network-example"
  address_space       = ["10.10.0.0/16"]
  dns_servers         = ["10.10.0.4", "10.10.0.5"]

  subnets = {
    snet-app = {
      address_prefixes  = ["10.10.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
    snet-aci = {
      address_prefixes = ["10.10.2.0/24"]
      delegation = {
        name    = "aci"
        service = "Microsoft.ContainerInstance/containerGroups"
      }
    }
    snet-private-endpoints = {
      address_prefixes                  = ["10.10.3.0/24"]
      private_endpoint_network_policies = "Disabled"
    }
  }

  tags = {
    environment = "example"
    workload    = "networking"
  }
}

output "vnet_id" {
  description = "ID of the created virtual network."
  value       = module.virtual_network.id
}

output "subnet_ids" {
  description = "IDs of the created subnets."
  value       = module.virtual_network.subnet_ids
}
