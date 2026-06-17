# 0005 — Wrap and curate Azure Verified Modules; build custom only for gaps

Date: 2026-06-16. Status: accepted.

## Decision

The factory's default building block is a **pinned Azure Verified Module (AVM)**, not a
hand-written `azurerm` resource. For each capability we want to offer:

1. **Wrap** an *Available* AVM module when one exists and we are adding real value — our
   secure-default profile, a simplified/opinionated interface, or composing several modules
   into a pattern.
2. **Catalog-and-pin** (no wrapper) when AVM covers the capability and a thin wrapper would
   add nothing — record the blessed AVM source + version + an example, and point consumers
   at it directly.
3. **Build custom** (the existing skeleton + `make check` flow) **only** when there is a
   genuine AVM gap, or AVM's module is *Orphaned/Deprecated* and unfit for the requirement.

Every catalogued module records its `wrap | catalog | custom` classification and, when it
wraps AVM, the upstream source, pinned version, and AVM **lifecycle state**
(Available / Orphaned / Deprecated).

## Context

- AVM is now Microsoft's **single standard** for Azure IaC modules. The legacy Terraform
  Verified Modules index (`Azure/terraform-azure-modules`) was **archived June 2026** and
  consolidated into AVM; the custom platform module `caf-enterprise-scale` is slated to
  archive (~Aug 2026); the official Azure Landing Zones IaC accelerator is **itself built on
  AVM**. Hand-rolling commodity modules now means competing with free, Microsoft-supported,
  Well-Architected code and owning the maintenance forever.
- We serve four enterprise clients at different landing-zone maturity stages from **one
  shared source** (see [ADR 0002](0002-monorepo-with-per-module-tags.md) and the
  [maturity map](../adoption-maturity-map.md)). Standing on AVM lowers per-client
  time-to-value, reduces TCO, and reads as *lower lock-in* in a client risk review.
- The trade-off we accept: AVM support is **best-effort and response-only** (≈5 business
  days to triage/ETA a bug/security issue, 15 for features — *not* a fix guarantee), modules
  can become *Orphaned*, and telemetry is on by default. We must govern this, not ignore it.

## Consequences

- **Skeleton & `/new-module` change** (roadmap): scaffolding must support a "wrap a pinned
  AVM module" path, not only raw-`azurerm`. The `provider-researcher` flow extends to
  verifying the AVM module's current source, version, and lifecycle state before wrapping.
- **`make check` still applies** to wrappers; the test emphasis shifts from "did we
  configure the resource securely" to a **contract test** — "does our wrapper pass the right
  inputs/defaults to AVM." `mock_provider` keeps the loop credential-free.
- **Telemetry posture is set centrally** in wrappers (`enable_telemetry`), so all clients
  inherit one deliberate, auditable decision.
- **Drift tracking** (Renovate/Dependabot) watches AVM upstream + provider versions, since
  remediation is best-effort.
- **Escape hatch required:** a documented fork-on-need procedure for an AVM module that goes
  *Orphaned* or whose fix exceeds the response window — temporary fork, internal patch SLA,
  path back to upstream. Without it, "wrap AVM" is a single point of failure for a regulated
  client.
- `virtual-network` (raw `azurerm`) remains valid as the **v1 harness reference**; it is a
  candidate to re-anchor onto `avm-res-network-virtualnetwork`, or to keep as the worked
  example of the *custom* path.
- Revisit if AVM's support model materially degrades or a client mandate forbids upstream
  dependencies.

See [docs/concept.md](../concept.md) for the business rationale and the value-stack model.
