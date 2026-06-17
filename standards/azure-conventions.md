# Azure conventions (AVM-aligned)

Interfaces follow Azure Verified Modules conventions where practical, so consumers get
a uniform experience across modules and can migrate to/from AVM modules cheaply.

## AVM-first

The default building block is a **pinned Azure Verified Module (AVM)**, not hand-written
`azurerm` resources ([ADR 0005](../docs/adr/0005-wrap-curate-avm.md)). Before writing a new
module, check the live AVM index:

- **Wrap** an *Available* AVM module when we add real value — our secure-default profile, a
  simplified/opinionated interface, or a composite pattern.
- **Catalog-and-pin** (no wrapper) when a thin wrapper adds nothing — record the blessed AVM
  source + version + an example and point consumers at it directly.
- **Build custom** (the conventions below) only for a genuine AVM gap, or when AVM's module
  is Orphaned/Deprecated and unfit.

When wrapping, set `enable_telemetry` to the org default explicitly and record the wrapped
AVM source, pinned version, and lifecycle state in the catalog. The universal inputs and
secure-default rules below apply to custom modules and to the interface our wrappers expose.

## Universal inputs (every module)

- `name` (string, required) — name of the primary resource. Caller's naming policy.
- `location` (string, required) — no default; the landing zone decides regions.
- `resource_group_name` (string, required) — modules deploy INTO an existing RG.
- `tags` (map(string), default `{}`) — applied to every taggable resource the module
  creates. Modules merge their own metadata into caller tags, never replace them.

## Secure by default

Defaults must be the SECURE option even where Azure's own default is not:

- TLS minimum 1.2 (or newer) wherever configurable.
- Public network access disabled by default where the service supports private access;
  document the override clearly.
- Shared-key / local auth disabled by default where Entra ID auth exists.
- HTTPS-only / encryption-in-transit on.
- Subnet default outbound internet access disabled (explicit egress via NAT gateway).

If trivy flags a default at HIGH/CRITICAL, the default is wrong — fix the default,
do not suppress the finding.

## Standard optional interfaces

When the resource supports the capability, use these shapes (AVM-style). Do not build
them speculatively — add when a consumer needs them, but follow these shapes when you do:

- `diagnostic_settings` — `map(object)` routing categories to Log Analytics / storage /
  event hub.
- `private_endpoints` — `map(object)` with subnet ID, optional private DNS zone group.
- `role_assignments` — `map(object({ role_definition_id_or_name, principal_id, ... }))`.
- `lock` — `object({ kind = string })` with `CanNotDelete` or `ReadOnly`.

## Provider constraints

- `azurerm` pinned pessimistically to the current major: `version = "~> 4.0"`.
- `required_version = ">= 1.9"` for terraform core (cross-variable validation refs,
  stable test framework).
