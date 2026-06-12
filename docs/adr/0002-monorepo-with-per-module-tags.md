# 0002 — Monorepo with per-module release tags

Date: 2026-06-12. Status: accepted.

## Decision

All modules live in one repo under `modules/<name>`, versioned independently via git
tags `modules/<name>/vX.Y.Z`. Consumers reference tags, never branches.

## Context

Shared harness, standards, toolchain and CI in one place; agents see cross-module
conventions without leaving the repo. Per-module tags keep independent release cadence,
which repo-per-module would otherwise provide.

## Consequences

- CI computes the changed-module matrix from the diff; harness changes re-check all modules.
- Releasing requires the tag discipline encoded in /release-module.
- If a module must be open-sourced or registry-published separately, split it out then
  (revisit this ADR).
