# Module structure

Every module under `modules/<name>` has this exact shape. Humans and agents rely on the
predictability — do not improvise.

```
modules/<name>/
├── main.tf          # resources; split by concern only when > ~150 lines (network.tf, diagnostics.tf, rbac.tf)
├── variables.tf     # ALL variables, nothing else
├── outputs.tf       # ALL outputs, nothing else
├── locals.tf        # optional — only if the module genuinely needs locals
├── versions.tf      # terraform + provider version constraints, nothing else
├── README.md        # header + hand-written description; generated section between TF_DOCS markers
├── CHANGELOG.md     # keep-a-changelog format (see versioning.md)
├── examples/
│   ├── basic/       # REQUIRED — minimal viable usage
│   └── complete/    # REQUIRED — every feature exercised; doubles as living documentation
└── tests/
    ├── *.tftest.hcl     # REQUIRED — unit tests, mock_provider only (see testing.md)
    └── integration/     # optional — real-Azure tests, CI-only
```

Rules:

- One module manages ONE cohesive Azure capability. If the description needs the word
  "and", split the module.
- Modules never create their own resource group (unless the module IS the
  resource-group module). Take `resource_group_name` as input.
- No `provider` blocks inside modules — callers configure providers; examples carry
  their own provider block.
- No nested submodules (`modules/<name>/modules/...`) without an ADR justifying it.
- A module wrapping a single resource must add real value — validations, secure
  defaults, paired diagnostics. Otherwise consumers should use the resource directly.
- Every `examples/*` directory is init+validate gated (`make examples`). A feature no
  example exercises is unfinished work.
