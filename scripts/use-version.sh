#!/usr/bin/env bash
# Puts a version into public/ (the folder Firebase uploads). This does NOT deploy.
# Usage: ./scripts/use-version.sh <teaser|labor|born|announcement>
set -euo pipefail
cd "$(dirname "$0")/.."
v="${1:?usage: use-version.sh <version>}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
./scripts/build-version.sh "$v" "$tmp/site"

# Safety: only the full announcement may contain the baby's name.
if [ "$v" != "announcement" ] && grep -rIliE "beatrice|cariad" "$tmp/site" >/dev/null; then
  echo "Refusing: '$v' contains the baby's name:" >&2
  grep -rIliE "beatrice|cariad" "$tmp/site" >&2
  exit 1
fi

mkdir -p public
rsync -a --delete "$tmp/site/" public/
echo "public/ now contains the '$v' version. Review it, then deploy with:"
echo "  ./scripts/firebase.sh deploy --only hosting --project baby-brown-teaser-2026"
