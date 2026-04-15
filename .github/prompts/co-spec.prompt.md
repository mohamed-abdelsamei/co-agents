---
description: "Define, clarify, or refine what you want to build — gathers requirements through structured questions and produces a spec document."
agent: architect
argument-hint: "Describe your feature idea or name the feature to refine"
---

The user wants to specify or refine: **$INPUT**

## Mode Detection

1. **Check for existing requirements** — Scan `.co-agents/requirements/` for an existing file for this feature.
2. If found → **Refinement Mode** below.
3. If not found → **New Spec Mode** below.

## New Spec Mode

### This Is a Specification Session

Start with discovery questions — do NOT jump to producing a requirements document.

### Workflow

1. **Ask first** — Structured questions in batches of 3-5 (problem, scope, constraints, preferences, quality). Synthesize vague inputs into clarifying questions.
2. **Surface gaps** — Proactively raise what the user might be missing: security, error handling, edge cases, observability, deployment.
3. **Delegate research** — If a technology comparison is needed, delegate to `@researcher`.
4. **Produce requirements** — Save to `.co-agents/requirements/{feature}.md`. Choose a short prefix (3-4 uppercase letters) from the feature name for requirement IDs (e.g., `AUTH-REQ-001`). Every requirement must be testable.
5. **Self-validate** — Before presenting: every requirement is testable, no implementation details, scope boundaries explicit, constitution respected. Max 3 `[NEEDS CLARIFICATION]` markers.
6. **Record decisions** — Log architectural decisions in `.co-agents/decisions.md` (check for existing entries first — do not duplicate).

### Iteration Cap

Maximum **3 question batches** (3-5 questions each). After round 3, produce the requirements document with your best understanding. Use `[NEEDS CLARIFICATION]` for unresolved items.

## Refinement Mode

### This Is a Refinement Session

You are rewriting and cleaning existing artifacts — not doing exploratory discovery.

### Workflow

1. **Load all artifacts** — Read requirements, tasks, decisions, improvements, reviews for this feature.
2. **Present current state** — List each REQ-ID with status and summary. List tasks with status and which REQ-ID they reference. Flag issues: requirements with no tasks, tasks referencing changed requirements, completed tasks with shifted requirements, redundancies.
3. **Discuss changes** — Ask what to keep, rewrite, or drop. Any new requirements? Scope changes? Maximum **3 discussion rounds**.
4. **Rewrite requirements** — Keep unchanged REQ-IDs, revise changed ones with `(revised YYYY-MM-DD)` marker, mark dropped as `~~REQ-ID~~: (obsolete — {reason})`, add new with next available ID.
5. **Sync tasks** — Completed tasks for kept requirements: preserve. Completed for rewritten: mark `[!]`. Completed for dropped: mark `[obsolete]`. Not-started for dropped: remove. Not-started for rewritten: update acceptance criteria. Add new tasks for new requirements.
6. **Cascade updates** — Invalidated decisions → mark `superseded`. Addressed improvements → remove. Prior reviews → note as stale, suggest `/co-review`.
7. **Summary** — Table showing counts of kept/rewritten/dropped/added requirements and tasks.

## Clarification Sub-Flow

In either mode, if ambiguity remains after initial questions:
1. Scan for ambiguity — functional scope, data model, UX flow, non-functional targets, edge cases
2. Prioritize gaps by impact on planning accuracy
3. Ask targeted questions (max 3 rounds, 3-5 each) — state what's ambiguous, why it matters, recommended answer
4. Encode answers back into the requirements file

## Done When

Requirements file is saved to `.co-agents/requirements/`. Then suggest `/co-plan`.
