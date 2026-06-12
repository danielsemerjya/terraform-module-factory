# The harness

This repo is engineered so that coding agents (Claude Code) can write, maintain, and
release Terraform modules reliably. The core principle: **agent quality is bounded by
feedback loops, not prompts** — every standard we care about is a machine-checkable
gate; prose instructions exist only for what automation can't check yet.

## Layers

| Layer | Where | What it does |
|---|---|---|
| Gates | `Makefile` | `make check MODULE=x` = fmt → validate → tflint → trivy → docs-check → unit tests → examples. Binary pass/fail, specific errors. The agent's inner loop. |
| Toolchain | `.mise.toml` | Pinned versions, identical locally and in CI (via `jdx/mise-action`). No "works on my machine". |
| Context | `CLAUDE.md`, `standards/` | One page of rules of engagement; terse per-topic standards with good/bad examples. The skeleton in `templates/` is the strongest "document" — agents copy patterns better than they follow prose. |
| Skills | `.claude/skills/` | Team workflows as repeatable procedures: `/new-module`, `/review-module`, `/upgrade-provider`, `/research`, `/release-module`. |
| Subagents | `.claude/agents/` | `provider-researcher` grounds resource schemas in live docs (the #1 LLM failure mode in Terraform is hallucinated arguments); `module-reviewer` checks what gates can't (tautological validations, stale docs, meaningless tests). |
| Guardrails | `.claude/hooks/`, `.claude/settings.json` | PreToolUse hook hard-blocks `terraform apply/destroy/import/state/taint`; PostToolUse hook auto-formats edited `.tf` files; permission allowlist covers all gate commands so the loop runs friction-free. |
| CI | `.github/workflows/ci.yml` | Same Make targets, matrix over changed modules (harness changes re-check everything). CI can never disagree with the local loop. |
| Releases | `.github/workflows/release.yml` | Per-module tags `modules/<name>/vX.Y.Z` → GitHub release with the CHANGELOG section as notes. |

## Design rules for evolving the harness

1. **New standard? New check.** When you add a rule to `standards/`, ask how a gate can
   enforce it (tflint rule, trivy policy, a script in the Makefile). A rule only in
   prose will drift.
2. **Never let the agent weaken a gate.** Ignores/skips/deleted tests require explicit
   human approval — this is stated in `CLAUDE.md` and should be enforced in PR review.
3. **Keep the inner loop credential-free and fast.** Anything needing Azure creds
   belongs in `tests/integration/` (CI-only). If `make check` gets slow, fix that
   before anything else — loop latency is harness UX.
4. **CI must equal local.** Any check added to CI must be a Make target first.

## Testing the harness itself (next step)

A harness is a product; changes to it can regress agent behavior silently. Keep a small
set of golden tasks (e.g. "add a `flow_timeout_in_minutes` variable to virtual-network,
tested and documented") and run them through Claude Code after significant harness
changes. Score: did it research before writing? did `make check` pass without weakened
gates? did CHANGELOG/docs/tests all move together?
