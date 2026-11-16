#!/usr/bin/env bash
# Assembles one version into a folder: shared theme files + that version's own files.
# Usage: ./scripts/build-version.sh <version> <output-dir>
set -euo pipefail
cd "$(dirname "$0")/.."
v="${1:?usage: build-version.sh <version> <output-dir>}"
out="${2:?usage: build-version.sh <version> <output-dir>}"

if [ ! -d "versions/$v" ] || [ "${v:0:1}" = "_" ]; then
  echo "Unknown version '$v'. Available: $(ls versions | grep -v '^_' | tr '\n' ' ')" >&2
  exit 1
fi

mkdir -p "$out"
find "$out" -mindepth 1 -delete   # keep the folder itself so a running preview server stays valid
cp -R versions/_shared/. "$out/"
cp -R "versions/$v/." "$out/"
find "$out" -name .DS_Store -delete
