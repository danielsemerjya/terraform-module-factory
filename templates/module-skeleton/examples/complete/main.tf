provider "azurerm" {
  features {}
}

# Exercise EVERY feature of the module here — this example is living documentation
# and is init+validate gated.
module "MODULE_NAME" {
  source = "../.."

  name                = "TODO"
  location            = "westeurope"
  resource_group_name = "rg-example"

  tags = {
    environment = "example"
  }
}
