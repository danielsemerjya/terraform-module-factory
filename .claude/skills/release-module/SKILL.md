---
name: release-module
description: Cut a release for one module — finalize the CHANGELOG, compute the semver bump, create the per-module git tag. Use when asked to release, tag, or version a module.
---

# Release module

Input: module name. Versioning rules live in `standards/versioning.md`.

1. **Preconditions**: clean `git status` for `modules/<name>`; `make check MODULE=<name>`
   green. Abort with the reason if either fails.
2. Determine the bump from `[Unreleased]` CHANGELOG entries: anything under Breaking →
   major; Added → minor; only Fixed/Changed-internal → patch. Show your reasoning and
   the resulting `vX.Y.Z` before proceeding.
3. Move `[Unreleased]` content into a new `## [X.Y.Z] - <today>` section (keep an empty
   `[Unreleased]` skeleton above it).
4. Commit (`chore(<name>): release vX.Y.Z`), then create the annotated tag
   `modules/<name>/vX.Y.Z`.
5. **NEVER push the commit or tag without explicit user confirmation.** Pushing the tag
   triggers `.github/workflows/release.yml`, which publishes a GitHub release with the
   CHANGELOG section as notes.
