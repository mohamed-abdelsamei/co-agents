---
description: "Disambiguate requirements before planning — ask targeted questions and encode answers back into the spec."
agent: architect
argument-hint: "Name the feature or requirements file to clarify"
---

The user wants to clarify requirements for: **$INPUT**

## This Is a Clarification Session

Review an existing requirements document for ambiguity, gaps, and unstated assumptions — then resolve them. NOT a kickoff or planning session.

## Precondition

Requirements must exist in `.co-agents/requirements/`. If none exist, stop and suggest `/co-specify`.

## Workflow

1. **Scan for ambiguity** — Check: functional scope, data model, UX flow, non-functional targets, edge cases, terminology
2. **Prioritize gaps** — Rank by impact on planning accuracy
3. **Ask questions** — Maximum **5 targeted questions**, one at a time. For each: state what's ambiguous, why it matters, provide a recommended answer.
4. **Encode answers** — Update the requirements file inline after each answer
5. **Confirm** — Summarize changes and confirm requirements are ready

## Done When

All questions are resolved and the requirements file is updated. Then suggest `/co-plan`.
