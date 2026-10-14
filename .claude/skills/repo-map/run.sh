#!/usr/bin/env bash
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1
out=$(mktemp) || exit 1
trap 'rm -f "$out"' EXIT
(
  echo "## Files (depth 3)"
  find . -maxdepth 3 \
    \( -name .git -o -name node_modules -o -name vendor -o -name dist -o -name build -o -name target -o -name .venv \) -prune -o \
    -type f ! -name '*.lock' ! -name 'package-lock.json' ! -name 'pnpm-lock.yaml' ! -name 'yarn.lock' -print | sed 's|^\./||' | sort
  frc=${PIPESTATUS[0]}
  echo "## Entry points"
  for f in index.html package.json pyproject.toml go.mod Cargo.toml Makefile; do
    [ -f "$f" ] && echo "$f"
  done
  echo "## Top-level dirs"
  for d in */; do
    [ -d "$d" ] || continue
    d=${d%/}
    case "$d" in node_modules|vendor|dist|build|target|.venv) continue ;; esac
    purpose=""
    if [ -f "$d/README.md" ]; then
      purpose=$(grep -m1 -vE '^(#|[[:space:]]*$)' "$d/README.md")
    elif [ -f "$d/package.json" ]; then
      purpose=$(grep -m1 '"description"' "$d/package.json" | sed 's/.*"description"[^"]*"\([^"]*\)".*/\1/')
    fi
    echo "$d: ${purpose:-(no README/manifest)}"
  done
  exit "$frc"
) > "$out" 2>&1
rc=$?
head -n 80 "$out"
exit $rc
