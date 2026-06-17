# Adoption maturity map

One shared, curated source serves clients at **different landing-zone (ALZ) maturity
stages**. A client doesn't get a fork — it adopts the **module categories** and **version
pins** that fit its stage, varying behaviour through inputs. Microsoft endorses exactly this
graduated model: organisations implement *"all, some, or none"* of centralised platform
services ([CAF Ready](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/)).

This is the artifact to put in front of a client: *here is where you are, here is what's next.*

## The map

| Stage | Client profile | What they consume | Module categories | AVM we wrap / catalog |
|---|---|---|---|---|
| **0 — Greenfield** | No platform landing zone; deploys workloads into existing subscriptions | Leaf resource modules with secure defaults + worked examples | Resource modules | `avm-res-*` (network, key vault, storage, …) |
| **1 — Foundational** | Wants a governance baseline | + management groups, policy baseline, naming/tagging, central logging | Resource + **platform baseline** | AVM for Platform LZ (mgmt groups / policy) |
| **2 — Intermediate** | Central platform forming | + connectivity (hub-spoke / vWAN), full platform LZ, app-landing-zone patterns | + **connectivity & workload patterns** | AVM for Platform LZ, `avm-ptn-*` connectivity |
| **3 — Mature** | Platform team + self-service | + subscription vending, golden paths, policy-as-code, drift management | + **subscription vending** | `avm-ptn-alz-sub-vending` |

Each stage is **additive** — a Stage 3 client still consumes everything below it. A client
moving from Stage 1 → 2 adopts more categories and bumps pins; it does not migrate to a
different repo.

## Why one source works (and forks don't)

- **Consistency** — every client inherits the same secure defaults, the same `make check`
  bar, the same governance. A fix or hardening lands once and every client can pin to it.
- **Maturity is a consumption choice, not a code fork** — the structure of an Azure landing
  zone (one platform LZ + one or more application landing zones) is the same at every stage;
  clients differ in *how much* of it they've stood up
  ([CAF: landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)).
- **No backport tax** — per-client forks would force us to backport every security fix
  across four divergent copies. Pinning against one source removes that entirely
  (see [ADR 0002](adr/0002-monorepo-with-per-module-tags.md)).

## How a client pins

Each client references per-module release tags and varies behaviour via inputs — never a
branch, never a fork:

```hcl
module "virtual_network" {
  source = "git::https://github.com/<org>/terraform-module-factory.git//modules/virtual-network?ref=modules/virtual-network/v0.1.0"
  # client- and stage-specific inputs here
}
```

A Stage 0 client might pin only resource modules; a Stage 3 client additionally pins the
platform-LZ and subscription-vending wrappers. Same catalog, different slices.

See [docs/concept.md](concept.md) for the business rationale and
[docs/enhancement-roadmap.md](enhancement-roadmap.md) for what we build to fill out the
higher stages.
