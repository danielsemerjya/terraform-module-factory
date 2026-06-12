mock_provider "azurerm" {}

variables {
  name                = "vnet-test"
  location            = "westeurope"
  resource_group_name = "rg-test"
  address_space       = ["10.0.0.0/16"]
}

run "plans_with_minimal_inputs" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test"
    error_message = "virtual network name should come from var.name"
  }

  assert {
    # address_space is a set in azurerm 4.x — no index access
    condition     = contains(azurerm_virtual_network.this.address_space, "10.0.0.0/16")
    error_message = "address space should come from var.address_space"
  }

  assert {
    condition     = length(azurerm_subnet.this) == 0
    error_message = "no subnets should be planned when var.subnets is empty"
  }
}

run "creates_one_subnet_per_input" {
  command = plan

  variables {
    subnets = {
      snet-a = { address_prefixes = ["10.0.1.0/24"] }
      snet-b = { address_prefixes = ["10.0.2.0/24"] }
    }
  }

  assert {
    condition     = length(azurerm_subnet.this) == 2
    error_message = "expected exactly one subnet resource per entry in var.subnets"
  }

  assert {
    condition     = azurerm_subnet.this["snet-a"].address_prefixes[0] == "10.0.1.0/24"
    error_message = "subnet address prefixes should come from the subnet input object"
  }
}

run "applies_secure_subnet_defaults" {
  command = plan

  variables {
    subnets = {
      snet-a = { address_prefixes = ["10.0.1.0/24"] }
    }
  }

  assert {
    condition     = azurerm_subnet.this["snet-a"].default_outbound_access_enabled == false
    error_message = "default outbound access must be disabled by default (secure default)"
  }

  assert {
    condition     = azurerm_subnet.this["snet-a"].private_endpoint_network_policies == "Disabled"
    error_message = "private endpoint network policies must default to Disabled"
  }
}

run "wires_subnet_delegation" {
  command = plan

  variables {
    subnets = {
      snet-aci = {
        address_prefixes = ["10.0.3.0/24"]
        delegation = {
          name    = "aci"
          service = "Microsoft.ContainerInstance/containerGroups"
        }
      }
    }
  }

  assert {
    condition     = azurerm_subnet.this["snet-aci"].delegation[0].service_delegation[0].name == "Microsoft.ContainerInstance/containerGroups"
    error_message = "delegation service should be wired into service_delegation.name"
  }
}

run "rejects_invalid_name" {
  command = plan

  variables {
    name = "-bad-name"
  }

  expect_failures = [var.name]
}

run "rejects_empty_address_space" {
  command = plan

  variables {
    address_space = []
  }

  expect_failures = [var.address_space]
}

run "rejects_malformed_cidr" {
  command = plan

  variables {
    address_space = ["10.0.0.0/16", "not-a-cidr"]
  }

  expect_failures = [var.address_space]
}

run "rejects_invalid_private_endpoint_policy" {
  command = plan

  variables {
    subnets = {
      snet-a = {
        address_prefixes                  = ["10.0.1.0/24"]
        private_endpoint_network_policies = "Sometimes"
      }
    }
  }

  expect_failures = [var.subnets]
}
