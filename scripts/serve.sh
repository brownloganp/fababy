#!/usr/bin/env bash
# Previews a version locally. Nothing is deployed.
# Usage: ./scripts/serve.sh <version> [port]     e.g. ./scripts/serve.sh labor 8781
set -euo pipefail
cd "$(dirname "$0")/.."
v="${1:?usage: serve.sh <version> [port]}"
port="${2:-8780}"
./scripts/build-version.sh "$v" ".preview/$v"
echo "Serving '$v' at http://localhost:$port/  (Ctrl+C to stop)"
cd ".preview/$v" && exec python3 -m http.server "$port"
