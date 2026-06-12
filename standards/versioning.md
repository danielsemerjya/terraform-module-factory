# Versioning & releases

- Each module versions independently: semver, annotated git tag
  `modules/<name>/vX.Y.Z`.
- Consumers reference a tag, never a branch:
  `source = "git::<repo-url>//modules/<name>?ref=modules/<name>/vX.Y.Z"`

## What forces a MAJOR bump (breaking)

- Removing or renaming a variable or output.
- Tightening a variable type or making an optional input required.
- Changing a default such that an existing consumer's plan shows destroy/replace.
- Raising the minimum terraform version or the provider major.

## Minor / patch

- MINOR: new optional variables, outputs, or features with non-disruptive defaults.
- PATCH: fixes, docs, internal refactors that produce an identical plan for existing
  consumers.

## CHANGELOG (per module, keep-a-changelog format)

- Every change to a module adds an entry under `## [Unreleased]` in one of:
  `### Breaking`, `### Added`, `### Changed`, `### Fixed`.
- Releasing (/release-module) moves `[Unreleased]` into a dated `## [X.Y.Z]` section;
  pushing the tag publishes a GitHub release with that section as notes.

## Commits

Conventional commits with the module as scope:
`feat(virtual-network): add subnet delegation support`,
`fix(virtual-network): correct CIDR validation for IPv6`.
Harness-level changes use scope `harness`.
