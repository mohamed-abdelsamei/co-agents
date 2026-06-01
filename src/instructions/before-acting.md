---
description: "Universal pre-check applied to all agents before acting."
applyTo: "**"
---

# Before Acting

Run this pre-check before starting any task. Skip empty files (header-only with no real content).

1. **Scan `docs/`** — If it exists, read relevant architecture (`docs/architecture.md`) and design docs. If it doesn't exist, skip.
2. **Check `constitution.md`** — If `.co-agents/constitution.md` has content, read it and treat principles as non-negotiable. If empty, skip.
3. **Check `decisions.md`** — If `.co-agents/decisions.md` has entries, read them and respect prior choices. If empty, skip.
4. **Check relevant memory** — Read only the specific files your task needs from `.co-agents/` (requirements, tasks, research, etc.). Don't read everything.

## Efficiency Rules

- If a file contains only a header and no real content, skip it — don't process empty templates
- Avoid re-reading large or static files you've already loaded — but DO re-read mutable artifacts (`tasks/`, `requirements/`, files just edited) when they may have changed
- Don't repeat context the user already provided in their message
- Prefer tables and bullet lists over prose paragraphs
- Don't explain what you're about to do — just do it
