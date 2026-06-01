---
description: "Create documentation — reference docs, API docs, READMEs, topic explanations, or specs from research and code."
argument-hint: "What to document (e.g., 'API reference for auth module' or 'explain the event system')"
allowed-tools: Read, Grep, Glob, WebFetch, WebSearch, Edit, Write, Task, Bash
---

> Act as the **researcher** agent (`${CLAUDE_PLUGIN_ROOT}/agents/researcher.md`).

The user wants documentation for: **$ARGUMENTS**

## Before You Start

1. If audience, scope, or format are unclear — ask before writing (max 3 questions)
2. Read the actual source code and any existing docs for the target area
3. **Check for existing document** — If a document already exists in `docs/` or `.co-agents/` for this topic, **update it** rather than creating a new file. Revise outdated sections, add new content, update the `Last updated` date.
4. Choose the right document type (reference, explanation, spec, architecture)

## What to Deliver

- A well-structured document using real names, paths, and examples from the project
- Placed in `docs/` (reference docs, guides, explanations) or `.co-agents/research/` (research findings)
- Include "Last updated: YYYY-MM-DD" line

## Scope Guard

Documentation only. Do not modify source code or make architecture decisions. Do not write `docs/architecture.md`, `.co-agents/decisions.md`, `requirements/`, or `tasks/` — those belong to `@architect`; hand off if the doc implies changes to them.

## Done When

Document is saved in the correct location and cross-referenced with related docs.
