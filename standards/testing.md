# Testing

Native `terraform test`. Unit tests are the agent's inner loop — they MUST run with no
Azure credentials and no network beyond the one-time provider download.

## Unit tests — `modules/<name>/tests/*.tftest.hcl` (REQUIRED)

- First statement of every unit test file: `mock_provider "azurerm" {}`.
- `command = plan` for assertions on configuration values; use `command = apply`
  (against mocks) only when an assertion needs computed/mocked attributes.

Required coverage:

1. **Happy path** — plan succeeds with minimal required inputs; assert that key inputs
   land in the right resource attributes.
2. **Every `validation` block has a matching negative test** using
   `expect_failures = [var.<name>]`. No orphan validations, no orphan negative tests.
3. **Cardinality** — N entries in a `for_each` input produce exactly N planned
   resources, keyed as expected.
4. **Conditional logic** — feature flag off → resource absent; on → present and wired.

Assert real behavior, not input echoes: asserting `var.name == "x"` after setting it
to `"x"` tests nothing. Assert that the RESOURCE got the value.

## Integration tests — `tests/integration/*.tftest.hcl` (optional, CI-only)

- Real azurerm provider, OIDC-authenticated, run via `make test-integration` in CI only
  — never part of the local loop.
- Reserve for what mocks cannot prove: policy interactions, cross-resource references
  resolved by Azure, eventual-consistency behavior.

## Examples are tests

Every `examples/*` directory is init+validate gated by `make examples`. When you add a
feature, extend `examples/complete` to exercise it.
