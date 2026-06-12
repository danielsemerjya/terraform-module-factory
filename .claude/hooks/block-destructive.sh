#!/usr/bin/env bash
# PreToolUse hook: hard-block state-mutating terraform/tofu commands.
# The permission deny-list in settings.json is the first line of defense;
# this hook is the backstop that catches chained/compound commands.
set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')

if grep -qE '\b(terraform|tofu)\b[^|;&]*\b(apply|destroy|import|taint|untaint)\b' <<<"$cmd" \
  || grep -qE '\b(terraform|tofu)\b[[:space:]]+(-chdir=[^[:space:]]+[[:space:]]+)?state\b' <<<"$cmd"; then
  echo "BLOCKED by harness: state-mutating terraform commands (apply/destroy/import/state/taint) are forbidden in this repo. Work plan-level only: make check MODULE=<name>." >&2
  exit 2
fi

exit 0
