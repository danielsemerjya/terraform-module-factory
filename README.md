# Terraform Module Factory

A monorepo of reusable Azure (azurerm) Terraform modules — and the agentic engineering
harness that produces them. The "factory" is the point: this repo is built so that a
coding agent (Claude Code) can write, test, document, and release modules to the same
standard as a senior engineer, because every standard is enforced by machines, not memory.

## New to agentic engineering?

Letting an AI agent write infrastructure code sounds risky — and with nothing but a
prompt, it is. The core idea here is that **agent quality is bounded by feedback loops,
not prompts**. Instead of asking the agent to "please follow our standards", this repo
turns the standards into things a machine can check, block, or verify:

- **One gate command** — `make check MODULE=<name>` runs format, validate, lint,
  security scan, docs check, and unit tests. It's binary pass/fail with specific
  errors, so the agent iterates against real feedback instead of guessing. The same
  command is the definition of done for humans.
- **Guardrails** — a hook hard-blocks `terraform apply`/`destroy`/`state` so the agent
  can never touch real infrastructure; unit tests run against a mock provider, so the
  whole local loop is credential-free.
- **Grounded knowledge** — a research subagent checks resource schemas against live
  provider docs before code is written, because hallucinated arguments are the #1 LLM
  failure mode in Terraform.
- **Repeatable workflows** — team procedures like "create a new module" or "upgrade the
  provider" are encoded as Claude Code skills (`/new-module`, `/upgrade-provider`), so
  the agent follows the same steps every time.
- **CI equals local** — CI runs the same Make targets, so the agent's local loop can
  never disagree with the pipeline.

The full design — layers, rationale, and rules for evolving it — is in
[docs/harness.md](docs/harness.md).

## Modules

| Module | Description |
|---|---|
| [virtual-network](modules/virtual-network) | Virtual network with subnets — private-endpoint-ready, secure egress defaults |

## Consuming a module

Reference a per-module release tag (never a branch):

```hcl
module "virtual_network" {
  source = "git::https://github.com/<org>/terraform-module-factory.git//modules/virtual-network?ref=modules/virtual-network/v0.1.0"
  # ...
}
```

## Contributing (humans and agents alike)

```sh
mise install                       # pinned toolchain (terraform, tflint, terraform-docs, trivy)
make help                          # all targets
make check MODULE=virtual-network  # the only definition of done
```

- Standards live in [standards/](standards) — every rule is enforced by a gate where
  automation allows; the rest is checked in review.
- New modules start from [templates/module-skeleton](templates/module-skeleton)
  (`/new-module` in Claude Code).
- Unit tests are credential-free (`mock_provider`); nothing in the local loop ever
  touches a real Azure subscription.
- Versioning and releases: [standards/versioning.md](standards/versioning.md).
