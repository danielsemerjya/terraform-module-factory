# Naming

## Module names

- kebab-case, named after the Azure capability: `virtual-network`, `storage-account`,
  `key-vault`.
- No provider prefix in the folder name (the repo is Azure-only); release tags carry
  the module name: `modules/virtual-network/v1.2.0`.

## Terraform identifiers

- Variables, locals, outputs: `snake_case`.
- The module's primary resource gets the label `this`:
  `azurerm_virtual_network.this`.
- A `for_each` collection of one resource type also uses `this`:
  `azurerm_subnet.this`. Secondary single-purpose resources get role-describing
  labels: `azurerm_monitor_diagnostic_setting.vnet`.
- Never repeat the type in the label: `azurerm_subnet.subnet` is forbidden.

## Azure resource names

- Resource names come from inputs. Modules do NOT invent naming conventions —
  landing-zone naming policy belongs to the caller.
- Validate Azure naming constraints (length, charset, start/end characters) in the
  variable so failures happen at plan time, not at apply time. Research the actual
  limits when writing the validation (/research) — do not guess them.

## Files

- Concern-split files are lowercase nouns: `network.tf`, `diagnostics.tf`, `rbac.tf`.
