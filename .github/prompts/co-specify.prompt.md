---
description: "Define what you want to build — gathers requirements through structured questions, suggests best practices, and produces a requirements document."
agent: architect
argument-hint: "Describe your project idea or feature in a few sentences"
---

The user wants to specify: **$INPUT**

## This Is a Specification Session

Start with discovery questions — do NOT jump to producing a requirements document.

## Workflow

1. **Ask first** — Structured questions in batches of 3-5 (problem, scope, constraints, preferences, quality). Synthesize vague inputs into clarifying questions.
2. **Surface gaps** — Proactively raise what the user might be missing: security, error handling, edge cases, observability, deployment.
3. **Delegate research** — If a technology comparison is needed, delegate to `@researcher`.
4. **Produce requirements** — Save to `.co-agents/requirements/{feature}.md`. Every requirement must be testable.
5. **Self-validate** — Before presenting: every requirement is testable, no implementation details, scope boundaries explicit, constitution respected. Max 3 `[NEEDS CLARIFICATION]` markers.
6. **Record decisions** — Log architectural decisions in `.co-agents/decisions.md`.

## Iteration Cap

Maximum **3 question batches** (3-5 questions each). After round 3, produce the requirements document with your best understanding. Use `[NEEDS CLARIFICATION]` for unresolved items.

## Done When

Requirements file is saved to `.co-agents/requirements/`. Then suggest `/co-clarify` to resolve ambiguities, then `/co-plan`.
