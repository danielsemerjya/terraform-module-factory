# 0004 — Make as the single gate entrypoint

Date: 2026-06-12. Status: accepted.

## Decision

All quality gates run through `make check MODULE=<name>`. CI calls the same targets.
Tool versions are pinned in `.mise.toml` and installed identically locally and in CI.

## Context

Agents converge fastest on one command with binary pass/fail and specific errors.
Multiple entry points (pre-commit here, CI-only checks there) create gaps where local
green ≠ CI green, which burns agent iterations and human trust.

## Consequences

- Adding any new check means adding a Make target and wiring it into `check`.
- Make's quirks (tabs, shell escaping) are accepted; if the Makefile outgrows itself,
  migrate to `task`/`just` wholesale via a new ADR — never split across both.
