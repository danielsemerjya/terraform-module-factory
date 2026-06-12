---
name: review-module
description: Review a Terraform module against repo standards and gates, reporting findings without fixing them. Use when asked to review or audit a module, or before a release.
---

# Review module

Input: module name. Findings only — do NOT fix anything unless the user asks afterwards.

1. Run `make check MODULE=<name>`; capture any gate failures verbatim.
2. Spawn the module-reviewer agent with the module path. It checks compliance with
   `standards/` beyond what the automated gates can catch (tautological validations,
   stale descriptions, meaningless tests, insecure defaults, missing outputs).
3. Cross-check documentation honesty yourself:
   - README description vs what the code actually does
   - CHANGELOG `[Unreleased]` vs `git log -- modules/<name>` since the last
     `modules/<name>/v*` tag
   - every documented feature exercised by at least one example
4. Report a single findings table: `severity | file:line | standard | finding |
   suggested fix`, severities blocker/warn/nit, followed by a one-paragraph verdict
   (releasable or not, and what blocks it).
