tflint {
  required_version = ">= 0.50"
}

# Core terraform language rules: naming conventions, documented/typed variables,
# unused declarations, standard module structure, pinned providers.
plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Azure-specific rules: invalid resource arguments, deprecated patterns.
plugin "azurerm" {
  enabled = true
  version = "0.32.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
