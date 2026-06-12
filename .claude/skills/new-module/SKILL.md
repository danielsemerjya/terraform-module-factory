---
name: new-module
description: Scaffold a new Azure Terraform module from the skeleton template, research its resources, implement, test, and document it until all gates pass. Use when the user asks to create or add a new module.
---

# New module

Input: module name (kebab-case, names the Azure capability — see `standards/naming.md`)
and a one-line purpose. If either is missing, ask before scaffolding.

1. **Scaffold**: `cp -R templates/module-skeleton modules/<name>`, then replace every
   `MODULE_NAME` placeholder (README.md, CHANGELOG.md, examples).
2. **Research**: spawn the provider-researcher agent for each azurerm resource the module
   will manage. Get current arguments, blocks, and constraints — never write resources
   from memory.
3. **Design the interface first**: write `variables.tf` and `outputs.tf` per
   `standards/variables-outputs.md` and `standards/azure-conventions.md` (universal
   inputs, secure defaults). If scope is ambiguous, show the user the proposed interface
   before implementing.
4. **Implement** `main.tf`; split into concern-named files per
   `standards/module-structure.md` only when it grows past ~150 lines.
5. **Test**: unit tests with `mock_provider` per `standards/testing.md` — happy path with
   attribute assertions, an `expect_failures` test for every validation block,
   cardinality tests for `for_each` resources, feature-flag on/off tests.
6. **Examples**: `examples/basic` (minimal required inputs) and `examples/complete`
   (every feature exercised).
7. **Document**: write the README header description by hand, then
   `make docs MODULE=<name>` for the generated section.
8. **Gate**: `make check MODULE=<name>` until green. Do not weaken gates to pass.
9. **Register**: add a row to the module table in the root README; confirm
   `CHANGELOG.md` has the initial entry under `[Unreleased]`.
