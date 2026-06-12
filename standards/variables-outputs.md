# Variables & outputs

## Variables

- Every variable has an explicit `type` and non-empty `description`. tflint enforces
  presence; YOU ensure the description states units, allowed values, and consequences.
- Never `type = any`. Model structures with `object()` / `map(object())` and
  `optional(attr, default)` for optional attributes.
- Required inputs are only those with no safe default: `name`, `location`,
  `resource_group_name`, address spaces. Everything else gets a SECURE default
  (see azure-conventions.md).
- Every constrained input gets a `validation` block with an actionable
  `error_message`. A validation that cannot fail is a bug — the reviewer checks for
  tautologies.
- Collections: prefer `map(object)` over `list(object)` when items have identity — map
  keys give stable `for_each` addresses, so reordering doesn't destroy resources.
- Booleans are named `<thing>_enabled` and never negated. `disable_x` is forbidden.
- Secrets: mark `sensitive = true`; better, accept a resource ID/reference instead of
  the secret value itself.

Good:

```hcl
variable "address_space" {
  type        = list(string)
  description = "CIDR ranges for the virtual network, e.g. [\"10.0.0.0/16\"]. At least one is required."

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for c in var.address_space : can(cidrhost(c, 0))])
    error_message = "address_space must contain at least one valid CIDR range (e.g. \"10.0.0.0/16\")."
  }
}
```

Bad:

```hcl
variable "config" { type = any }   # untyped grab-bag — consumers get no contract
variable "name" { type = string }  # no description, no constraint validation
variable "disable_https" {}        # negated boolean AND insecure default direction
```

## Outputs

- Every output has a `description`.
- Output everything a consumer plausibly composes on: at minimum `id` and `name` of
  every created resource; `for_each` resources are output as maps keyed identically to
  the input map.
- Never output secret values unless unavoidable; then `sensitive = true`.
- Don't re-output inputs unchanged unless the module normalized or computed them.
