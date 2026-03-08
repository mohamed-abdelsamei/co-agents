---
description: "Create documentation — reference docs, API docs, READMEs, topic explanations, or specs from research and code."
agent: researcher
argument-hint: "What to document (e.g., 'API reference for auth module' or 'explain the event system')"
---

The user wants documentation for: **$INPUT**

## Before You Start

1. If audience, scope, or format are unclear — ask before writing (max 3 questions)
2. Read the actual source code and any existing docs for the target area
3. Choose the right document type (reference, explanation, spec, architecture)

## What to Deliver

- A well-structured document using real names, paths, and examples from the project
- Placed in `docs/` (general) or `.co-agents/` (project memory)
- Include "Last updated: YYYY-MM-DD" line

## Scope Guard

Documentation only. Do not modify source code or make architecture decisions. If the request requires those, suggest `@architect` or `@engineer`.

## Done When

Document is saved in the correct location and cross-referenced with related docs.
