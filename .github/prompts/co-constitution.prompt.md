---
description: "Define project principles, quality gates, and constraints that all agents must respect."
agent: architect
argument-hint: "Describe your project or the area you want to set principles for"
---

The user wants to establish project principles for: **$INPUT**

## This Is a Constitution Session

You are creating (or updating) the project's constitution — non-negotiable principles, quality gates, and constraints. This is NOT a requirements session.

## Workflow

1. Check if `.co-agents/constitution.md` already has content — if so, you are **updating**
2. Scan the codebase for conventions already in practice
3. **Ask up to 2 batches of questions** (3-5 each) covering: quality standards, security rules, technical constraints, conventions, governance
4. **Infer from codebase** — Suggest observed principles, marked as `inferred` for user confirmation
5. **Produce constitution** — Save to `.co-agents/constitution.md` using the template
6. **Record decision** — Log in `.co-agents/decisions.md`

## Iteration Cap

Maximum **2 question rounds**. After round 2, produce the constitution with your best understanding. Mark unresolved areas with `[NEEDS CONFIRMATION]`.

## Done When

`constitution.md` is saved and the user has confirmed the principles. Then suggest `/co-specify`.
