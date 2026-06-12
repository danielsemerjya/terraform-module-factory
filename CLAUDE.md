# Azure Terraform Module Factory

Monorepo of reusable Azure (azurerm) Terraform modules. One folder per module under
`modules/<name>`; every module has the identical canonical shape (see `templates/module-skeleton/`).

## The one command that matters

```
make check MODULE=<name>   # fmt + validate + tflint + trivy + docs-check + unit tests + examples
```

Work on a module is complete ONLY when this passes — run it before declaring any task done.
`make help` lists individual targets. Regenerate docs with `make docs MODULE=<name>`; never
hand-edit the generated README section between the `TF_DOCS` markers.

## Hard rules

- NEVER run `terraform apply`, `destroy`, `import`, `state`, or `taint`. This repo is
  plan-level only; a PreToolUse hook blocks these commands.
- Never weaken a gate to make it pass (tflint ignores, trivy skips, deleted tests,
  loosened validations) without explicit user approval — say what's failing instead.
- Before writing any azurerm resource or argument, verify the schema against current
  provider docs (provider-researcher agent or /research). Do not trust memory — provider
  APIs drift, and `terraform validate` only catches what the downloaded schema knows.
- New modules: scaffold from `templates/module-skeleton` (use /new-module), never from scratch.

## Standards

Read the relevant file in `standards/` before writing code:

- `module-structure.md` — canonical file layout, examples/, tests/
- `variables-outputs.md` — typing, validation, descriptions
- `naming.md` — module / resource / variable naming
- `azure-conventions.md` — universal inputs, secure defaults, AVM-aligned interfaces
- `testing.md` — required unit-test coverage (mock provider)
- `versioning.md` — semver, per-module tags `modules/<name>/vX.Y.Z`, CHANGELOG rules

## Definition of done for any module change

1. `make check MODULE=<name>` is green.
2. Variable/output changes carry: validation where applicable, a test exercising it,
   regenerated docs (`make docs`).
3. `CHANGELOG.md` entry under `## [Unreleased]`.
4. User-facing behavior changes are visible in an example under `examples/`.
