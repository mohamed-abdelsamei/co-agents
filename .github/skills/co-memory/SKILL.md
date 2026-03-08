---
name: co-memory
description: "**WORKFLOW SKILL** — Project memory structure and conventions. USE when reading from or writing to .co-agents/ files."
---

# Project Memory

Full templates, agent permissions, and conventions are defined in `.github/instructions/memory.instructions.md` (auto-applied when editing `.co-agents/**` files).

## Quick Reference

- **`docs/`** — Source of truth for architecture, research, specs. Read first. Wins on conflicts.
- **`.co-agents/`** — Operational tracking: decisions, tasks, requirements, reviews, experiments.

## Agent Permissions

| Agent | Writes |
|-------|--------|
| `architect` | `docs/`, `requirements/`, `tasks/`, `decisions.md` |
| `engineer` | `tasks/` (status), `decisions.md`, `improvements.md`, `experiments/` |
| `reviewer` | `reviews/` only |
| `researcher` | `docs/`, `research/` |

## Task Status

- `[ ]` Not started · `[~]` In progress · `[x]` Done · `[-]` Blocked
