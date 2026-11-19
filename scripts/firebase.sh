#!/usr/bin/env bash
# Runs the Firebase CLI on Node 20 using the public npm registry.
# ~/.npmrc is ignored on purpose: here it points at a work registry with expired credentials.
# Usage: ./scripts/firebase.sh <firebase args>   e.g. ./scripts/firebase.sh login
set -euo pipefail
# Use nvm's Node 20 if nvm is installed; otherwise fall back to whatever Node (>= 20) is on PATH.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
  nvm use 20 >/dev/null
fi
export NPM_CONFIG_USERCONFIG=/dev/null NPM_CONFIG_REGISTRY=https://registry.npmjs.org/
exec npx --yes firebase-tools@latest "$@"
