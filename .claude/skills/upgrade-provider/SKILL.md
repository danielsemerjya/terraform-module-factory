---
name: upgrade-provider
description: Upgrade the azurerm provider or terraform core version constraint for one module or all modules — research breaking changes, apply fixes, prove gates green. Use for provider bumps, deprecation cleanups, or "update to azurerm X".
---

# Upgrade provider

Input: target version (or "latest") and module name (or "all").

1. Read the current constraint from `versions.tf` of each affected module.
2. **Research before touching code**: spawn the provider-researcher agent for the
   CHANGELOG diff between current and target versions. List breaking changes,
   renames, and deprecations that affect resources these modules actually use
   (grep for the resource types first).
3. Bump the constraint in `versions.tf`, then
   `terraform -chdir=modules/<m> init -backend=false -upgrade`.
4. Fix what the research, `terraform validate`, and `tflint` surface. Renamed
   arguments in a module's INTERFACE (variables/outputs) are breaking changes for
   consumers — flag them per `standards/versioning.md` instead of silently renaming.
5. `make check MODULE=<m>` per module. For "all", finish every module and report a
   table: module | old → new | changes made | gate status.
6. Add a `CHANGELOG.md` entry per touched module under `[Unreleased]`.
