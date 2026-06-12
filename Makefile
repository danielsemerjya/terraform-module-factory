SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

ROOT          := $(shell pwd)
MODULES       := $(notdir $(wildcard modules/*))
MODULE_DIR    := modules/$(MODULE)
TFLINT_CONFIG := $(ROOT)/.tflint.hcl
TFDOCS_CONFIG := $(ROOT)/.terraform-docs.yml

# Route every tool through the pinned toolchain when mise is available, so gates
# never silently run on a wrong PATH version (locally or in CI).
ifneq (,$(shell command -v mise 2>/dev/null))
RUN := mise exec --
endif

.PHONY: help guard-module check check-all fmt fmt-fix init validate lint security docs docs-check test test-integration examples clean

help: ## List available targets
	@grep -hE '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "  Most targets need MODULE=<name>. Available modules: $(MODULES)"

guard-module:
	@test -n "$(MODULE)" || { echo "ERROR: set MODULE=<name>. Available: $(MODULES)"; exit 1; }
	@test -d "$(MODULE_DIR)" || { echo "ERROR: $(MODULE_DIR) not found. Available: $(MODULES)"; exit 1; }

check: guard-module fmt validate lint security docs-check test examples ## Run ALL gates for MODULE
	@echo ""
	@echo "✓ All gates passed for module '$(MODULE)'"

check-all: ## Run all gates for every module
	@set -e; for m in $(MODULES); do $(MAKE) --no-print-directory check MODULE=$$m; done

fmt: guard-module ## Gate: formatting (read-only check)
	@echo "── fmt ──────────────────────────────────────────"
	@$(RUN) terraform -chdir=$(MODULE_DIR) fmt -check -recursive -diff

fmt-fix: guard-module ## Fix formatting in place
	@$(RUN) terraform -chdir=$(MODULE_DIR) fmt -recursive

init: guard-module
	@if [ -n "$$TF_PLUGIN_CACHE_DIR" ]; then mkdir -p "$$TF_PLUGIN_CACHE_DIR"; fi
	@$(RUN) terraform -chdir=$(MODULE_DIR) init -backend=false -input=false > /dev/null

validate: guard-module init ## Gate: terraform validate (schema-checks resources)
	@echo "── validate ─────────────────────────────────────"
	@$(RUN) terraform -chdir=$(MODULE_DIR) validate

lint: guard-module ## Gate: tflint (terraform + azurerm rulesets)
	@echo "── lint ─────────────────────────────────────────"
	@$(RUN) tflint --init --config=$(TFLINT_CONFIG) > /dev/null
	@$(RUN) tflint --config=$(TFLINT_CONFIG) --chdir=$(MODULE_DIR)

security: guard-module ## Gate: trivy IaC misconfiguration scan
	@echo "── security ─────────────────────────────────────"
	@$(RUN) trivy config --exit-code 1 --severity HIGH,CRITICAL --quiet $(MODULE_DIR)

docs: guard-module ## Regenerate README.md from terraform-docs
	@$(RUN) terraform-docs --config $(TFDOCS_CONFIG) $(MODULE_DIR)

docs-check: guard-module ## Gate: README.md is in sync with the code
	@echo "── docs ─────────────────────────────────────────"
	@$(RUN) terraform-docs --config $(TFDOCS_CONFIG) --output-check $(MODULE_DIR) \
		|| { echo "README out of date — run: make docs MODULE=$(MODULE)"; exit 1; }

test: guard-module init ## Gate: unit tests (mock providers, no Azure creds)
	@echo "── test ─────────────────────────────────────────"
	@$(RUN) terraform -chdir=$(MODULE_DIR) test

test-integration: guard-module init ## Integration tests (real Azure, CI-only)
	@$(RUN) terraform -chdir=$(MODULE_DIR) test -test-directory=tests/integration

examples: guard-module ## Gate: every example inits and validates
	@echo "── examples ─────────────────────────────────────"
	@if [ -n "$$TF_PLUGIN_CACHE_DIR" ]; then mkdir -p "$$TF_PLUGIN_CACHE_DIR"; fi
	@set -e; for ex in $(MODULE_DIR)/examples/*/; do \
		echo "validating $$ex"; \
		$(RUN) terraform -chdir=$$ex init -backend=false -input=false > /dev/null; \
		$(RUN) terraform -chdir=$$ex validate; \
	done

clean: ## Remove .terraform dirs and lock files across all modules
	@find modules -type d -name ".terraform" -prune -exec rm -rf {} +
	@find modules -name ".terraform.lock.hcl" -delete
