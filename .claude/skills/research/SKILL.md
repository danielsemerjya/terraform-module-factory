---
name: research
description: Look up current, authoritative documentation for azurerm resources, Terraform language features, or Azure service constraints before writing code. Use whenever a resource schema, argument, or limit is involved.
---

# Research

Ground every schema claim in a source fetched THIS session — never training data.
Provider APIs drift; a hallucinated argument is the most common failure mode in
LLM-written Terraform.

1. Prefer Context7 MCP: `resolve-library-id` for `terraform-provider-azurerm` (or the
   relevant library), then `query-docs` with the full question.
2. Fall back to the Terraform Registry resource page via WebFetch:
   `https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/<name>`
3. For Azure service limits and naming rules (lengths, charsets, quotas), use Microsoft
   Learn docs via WebSearch/WebFetch.

Return, compactly:
- arguments/blocks with type, required/optional, default, constraints
- deprecations or upcoming breaking changes relevant to the planned usage
- a minimal valid HCL example
- which provider version the information reflects

Anything you could not verify, mark **UNVERIFIED** — do not guess.
