#!/usr/bin/env bash
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1
base=${1:-origin/main}
out=$(mktemp) || exit 1
trap 'rm -f "$out"' EXIT
git diff --stat "$base"...HEAD > "$out" 2>&1
rc=$?
if [ "$rc" -eq 0 ]; then
  echo "## Changed functions/sections" >> "$out"
  git diff -U0 --no-color "$base"...HEAD | awk '
    /^\+\+\+ / { file = substr($0, 7); next }
    /^@@/ { sub(/^@@[^@]*@@ ?/, ""); if ($0 != "") names[file] = names[file] ", " $0; next }
    /^[+-][^+-]/ && match($0, /function [A-Za-z0-9_$]+/) { names[file] = names[file] ", " substr($0, RSTART + 9, RLENGTH - 9) }
    END { for (f in names) { s = substr(names[f], 3); print f ": " s } }
  ' | cut -c1-200 | sort -u >> "$out"
fi
head -n 60 "$out"
exit $rc
