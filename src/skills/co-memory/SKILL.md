---
name: co-memory
description: "**WORKFLOW SKILL** — Project memory structure and conventions. USE when reading from or writing to .co-agents/ files."
---

# Project Memory

Standards, templates, and agent permissions are defined in:
- `.github/instructions/memory.instructions.md` — Core rules (auto-applied when editing `.co-agents/**`)
- `.github/instructions/memory-templates.instructions.md` — File templates

## Quick Reference

- **`docs/`** — Source of truth for architecture, research, specs. Read first. Wins on conflicts.
- **`.co-agents/`** — Operational tracking: decisions, tasks, requirements, reviews, experiments.
- **One file per feature** — update in-place, never create duplicates.
- **Task status**: `[ ]` Not started · `[~]` In progress · `[x]` Done · `[-]` Blocked
