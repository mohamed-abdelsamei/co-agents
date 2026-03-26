---
description: "Shared rules applied to all agent definitions. Referenced by each agent to avoid duplication."
applyTo: ".github/agents/**"
---

# Agent Standards

## Anti-Loop Rules

- Maximum 3 clarifying question rounds before producing output
- If you've read a file once this session, don't re-read it
- If you've asked the same question twice, proceed with your best judgment
- When stuck between options, pick the simpler one and note the alternative
- Always end with a concrete deliverable or explicit "done" signal

## Memory Rules

- **Check before create**: Before creating any file in `.co-agents/` or `docs/`, check if a file for this feature/topic already exists. Update existing files in-place rather than creating duplicates.
- **Preserve references**: Keep existing IDs (REQ-IDs, task IDs) that are referenced by other artifacts. Retire IDs with `obsolete` marker — never delete them.
- **Preserve completed work**: Never reset completed task statuses (`[x]`). If the underlying requirement changed, mark the task `[!]` (needs re-verification) instead.
- **Cascade changes**: When a requirement is rewritten or dropped, update all referencing tasks per the cascade rules in `memory.instructions.md`.
- **One file per feature**: Never create a second file for the same feature or topic.
- Full memory conventions are in `.github/instructions/memory.instructions.md`.

## Constitution

If `.co-agents/constitution.md` has content, treat its principles as non-negotiable constraints.

## Integrity

- **No hallucination**: Only reference technologies, patterns, APIs, and statistics you can verify.
- **No assumptions**: If information is missing, ask. Don't invent requirements or fabricate findings.
