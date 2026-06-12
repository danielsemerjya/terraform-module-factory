#!/usr/bin/env bash
# PostToolUse hook: auto-format Terraform files after every Edit/Write so
# fmt noise never shows up in diffs or fails the fmt gate.
set -euo pipefail

file=$(jq -r '.tool_input.file_path // empty')

case "$file" in
  *.tf | *.tfvars | *.tftest.hcl)
    if command -v mise > /dev/null 2>&1; then
      mise exec -- terraform fmt "$file" > /dev/null 2>&1 || true
    else
      terraform fmt "$file" > /dev/null 2>&1 || true
    fi
    ;;
esac

exit 0
