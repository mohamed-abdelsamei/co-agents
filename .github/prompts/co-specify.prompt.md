---
description: "Define what you want to build — gathers requirements through structured questions, suggests best practices, and produces a requirements document."
agent: architect
argument-hint: "Describe your project idea or feature in a few sentences"
---

The user wants to specify: **$INPUT**

## This Is a Specification Session

Start with discovery questions — do NOT jump to producing a requirements document.

## Workflow

1. **Check for existing requirements** — Scan `.co-agents/requirements/` for an existing file for this feature. If found, load it and treat this as a **requirements update session**: present the current requirements, ask what changed, and update in-place. Preserve existing requirement IDs that are still valid. Mark dropped requirements as `obsolete` with a reason (don't delete — retire the ID). If requirements were rewritten, apply cascade rules: flag dependent tasks for re-verification. If not found, proceed with new requirements discovery.
2. **Ask first** — Structured questions in batches of 3-5 (problem, scope, constraints, preferences, quality). Synthesize vague inputs into clarifying questions.
2. **Surface gaps** — Proactively raise what the user might be missing: security, error handling, edge cases, observability, deployment.
3. **Delegate research** — If a technology comparison is needed, delegate to `@researcher`.
5. **Produce requirements** — Save to `.co-agents/requirements/{feature}.md` (update existing file if one was found in step 1). Choose a short prefix (3-4 uppercase letters) from the feature name for requirement IDs (e.g., `AUTH-REQ-001`). Every requirement must be testable.
6. **Self-validate** — Before presenting: every requirement is testable, no implementation details, scope boundaries explicit, constitution respected. Max 3 `[NEEDS CLARIFICATION]` markers.
7. **Record decisions** — Log architectural decisions in `.co-agents/decisions.md` (check for existing entries first — do not duplicate).

## Iteration Cap

Maximum **3 question batches** (3-5 questions each). After round 3, produce the requirements document with your best understanding. Use `[NEEDS CLARIFICATION]` for unresolved items.

## Done When

Requirements file is saved to `.co-agents/requirements/`. Then suggest `/co-clarify` to resolve ambiguities, then `/co-plan`.
