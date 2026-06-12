# 0003 — Native terraform test with mock providers

Date: 2026-06-12. Status: accepted.

## Decision

Unit testing uses native `terraform test` (`.tftest.hcl`) with `mock_provider`,
required for every module. Terratest is not used. Real-Azure integration tests are
optional, live in `tests/integration/`, and run only in CI.

## Context

The agent's inner loop must be fast, credential-free, and in a language the agent
already writes (HCL, not Go). Mock providers (Terraform ≥ 1.7) give plan/apply-level
assertions without touching Azure.

## Consequences

- No real-infrastructure verification in the local loop — that's deliberate; CI owns it.
- If a future need exceeds the native framework (complex orchestration, retries,
  drift checks), add Terratest for that case via a new ADR rather than migrating.
