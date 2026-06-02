---
name: co-memory
description: "**WORKFLOW SKILL** — Project memory structure and conventions. USE when reading from or writing to .co-agents/ files."
---

# Project Memory

Standards, templates, and agent permissions are defined in:
- `${CLAUDE_PLUGIN_ROOT}/instructions/memory.md` — Core rules (auto-applied when editing `.co-agents/**`)
- `${CLAUDE_PLUGIN_ROOT}/instructions/memory-templates.md` — File templates

## Quick Reference

- **`docs/`** — durable source-of-truth documents: the architecture overview (`docs/architecture.md`), design specs, API references, guides.
- **`.co-agents/`** — operational memory: constitution, decisions, improvements, requirements, tasks, reviews, research findings, experiments.
- **One home per artifact** — never keep duplicate copies across `docs/` and `.co-agents/`.
- **One file per feature** — update in-place, never create duplicates.
- **Task status**: `[ ]` not started · `[~]` in progress · `[x]` done · `[!]` needs re-verification · `[-]` blocked · `[obsolete]` no longer needed
