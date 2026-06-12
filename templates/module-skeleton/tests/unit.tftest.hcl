mock_provider "azurerm" {}

variables {
  name                = "TODO"
  location            = "westeurope"
  resource_group_name = "rg-test"
}

# Required coverage (standards/testing.md):
#   1. happy-path plan with key attribute assertions
#   2. an expect_failures test for EVERY validation block
#   3. cardinality tests for for_each resources
#   4. feature-flag on/off tests
#
# run "plans_with_minimal_inputs" {
#   command = plan
#
#   assert {
#     condition     = azurerm_TODO.this.name == var.name
#     error_message = "primary resource name should come from var.name"
#   }
# }
