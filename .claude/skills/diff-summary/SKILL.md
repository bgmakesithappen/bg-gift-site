---
name: diff-summary
description: Prints `git diff --stat` against a base ref (default origin/main) plus the changed function or section names per file. Use instead of reading full diffs.
---
Run: `bash .claude/skills/diff-summary/run.sh [args]`
Output: diffstat, then `file: name, name` lines from hunk headers and changed JS functions (max 60 lines).
Fall back to the raw command only if this output is insufficient to diagnose.
