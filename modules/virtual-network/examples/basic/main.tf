provider "azurerm" {
  features {}
}

module "virtual_network" {
  source = "../.."

  name                = "vnet-example-dev-weu-001"
  location            = "westeurope"
  resource_group_name = "rg-network-example"
  address_space       = ["10.0.0.0/16"]
}
