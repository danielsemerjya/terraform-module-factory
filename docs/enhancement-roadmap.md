# Enhancement roadmap

Prioritised plan to make the factory ready for adoption by four enterprise clients at
different ALZ maturity stages. Derived from fact-checked research against first-party
Microsoft / HashiCorp sources (see [Sources](#sources)). Pairs with
[the concept](concept.md), [ADR 0005](adr/0005-wrap-curate-avm.md), and the
[maturity map](adoption-maturity-map.md).

## Where we are

The **engineering harness is strong and proven** (single `make check` gate, mock-provider
tests, per-module semver tags, CI that mirrors local, agentic authoring + governance). The
gap is that the repo's *content* hasn't caught up to its *strategy*: the one module
(`virtual-network`) hand-rolls `azurerm` resources that AVM already covers. The work below
closes that gap and fills out the higher maturity stages.

## Quick wins (days — high leverage)

1. **Codify the AVM-first decision** — done: [ADR 0005](adr/0005-wrap-curate-avm.md). Add a
   short AVM-first section to `standards/azure-conventions.md` and a pointer in `CLAUDE.md`
   (done) so future agent work defaults to wrapping.
2. **Re-anchor the reference pattern** — update `templates/module-skeleton` and `/new-module`
   to scaffold a *wrap-a-pinned-AVM-module* path; either re-anchor `virtual-network` onto
   `avm-res-network-virtualnetwork` or keep it as the worked *custom* example and add a new
   AVM-wrapper reference module. Verify the live AVM source/version first, then `make check`.
3. **Publish the maturity-to-module map** — done: [adoption-maturity-map.md](adoption-maturity-map.md).
4. **Machine-readable catalog** — add `catalog.yaml` + generated `MODULES.md` recording per
   module: capability, `wrap | catalog | custom`, wrapped AVM source + pinned version +
   lifecycle state, maturity stage, status, examples. This is discoverability without
   registry infrastructure.
5. **Central telemetry default** — set `enable_telemetry` once in wrappers; document the
   org's posture.
6. **Drift automation** — add Renovate (Terraform manager) to track AVM upstream + provider
   bumps, since AVM remediation is best-effort.
7. **Human-contributor governance** — add `CODEOWNERS` + `CONTRIBUTING.md`; the current
   `CLAUDE.md` serves agents, not human reviewers from four client teams.
8. **Deprecation policy** — extend `standards/versioning.md` with how a module version is
   signalled and retired across clients.

## Strategic bets (weeks)

9. **Platform-LZ wrapper modules** over **AVM for Platform Landing Zone** (management groups,
   policy, connectivity) for Stage 1–2 clients — *not* the deprecating `caf-enterprise-scale`.
10. **Subscription-vending wrapper** over `avm-ptn-alz-sub-vending` for Stage 3 clients with
    a platform team.
11. **Policy-as-code gate** in `make check` (Checkov or OPA/Conftest alongside trivy) +
    CIS / Azure Security Benchmark mapping. Tier it (advisory vs blocking) so the
    most-regulated client is satisfied without over-burdening the least-mature one.
12. **Supply-chain hardening** — enforce `.terraform.lock.hcl` presence/pinning in CI, pin
    AVM versions, document a verification step.
13. **Cost visibility** — Infracost in CI / PR comments.
14. **Distribution upgrade (evaluate)** — git-tag sourcing already satisfies "one shared
    source, pinned per client"; assess a private registry (HCP Terraform vs Azure DevOps)
    only if cross-client discoverability becomes the bottleneck. *Not yet first-party
    verified — needs its own evaluation.*

## Escape hatch (must exist before adoption)

15. **Fork-on-need procedure** for an AVM module that goes *Orphaned* or whose fix exceeds
    AVM's best-effort response window: temporary fork, internal patch SLA, path back to
    upstream once a new owner appears. Without this, "wrap AVM" is a single point of failure
    for a regulated client.

## Re-verify before relying on these (time-sensitive)

- Exact AVM module taxonomy (resource / pattern / **utility**) — the "exactly two types"
  framing was refuted in research; don't write "two" into standards without re-checking.
- AVM support timeframes (the 5/15-business-day targets replaced an older 3-day statement)
  and specific AVM source paths/versions — these drift.
- Archive dates: TFVM index (done, Jun 2026), Terraform `lz-vending` (~Jun 2026, → AVM
  pattern module), `caf-enterprise-scale` (slated ~Aug 2026).

## Open decisions (yours to make)

- **Wrap-vs-build inventory** — which of the four clients' actual capabilities have an
  Available AVM module vs a real gap? (Needs a pass against the live AVM index.)
- **Distribution** — stay on git-tag sourcing, or invest in a private registry?
- **Policy-gate severity model** — how to satisfy the most-regulated client without blocking
  the least-mature one.

## Sources

- [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) · [lifecycle](https://azure.github.io/Azure-Verified-Modules/specs/shared/module-lifecycle/) · [support](https://azure.github.io/Azure-Verified-Modules/help-support/module-support/) · [telemetry](https://azure.github.io/Azure-Verified-Modules/help-support/telemetry/)
- [TFVM index — archived, consolidated into AVM](https://github.com/Azure/terraform-azure-modules)
- [CAF Ready](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/) · [landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) · [implementation options](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) · [subscription vending](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
- [Azure Landing Zones IaC accelerator](https://azure.github.io/Azure-Landing-Zones/accelerator/)
- [HashiCorp: module design](https://developer.hashicorp.com/well-architected-framework/define-and-automate-processes/define/modules) · [terraform test](https://developer.hashicorp.com/terraform/language/tests) · [Renovate Terraform](https://docs.renovatebot.com/modules/manager/terraform/) · [Infracost](https://github.com/infracost/actions)
