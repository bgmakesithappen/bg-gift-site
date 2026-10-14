---
name: repo-map
description: Prints a depth-3 file tree, HTML entry points, and a one-line purpose per top-level directory. Use before exploring an unfamiliar area of the repo.
---
Run: `bash .claude/skills/repo-map/run.sh [args]`
Output: indented file list, then entry points, then `dir: purpose` lines (max 80 lines).
Fall back to the raw command only if this output is insufficient to diagnose.
