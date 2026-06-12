provider "azurerm" {
  features {}
}

module "MODULE_NAME" {
  source = "../.."

  name                = "TODO"
  location            = "westeurope"
  resource_group_name = "rg-example"
}
