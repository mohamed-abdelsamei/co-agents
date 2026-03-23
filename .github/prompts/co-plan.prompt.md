---
description: "Plan implementation — break requirements into phased tasks with dependencies, acceptance criteria, and TDD markers."
agent: architect
argument-hint: "Feature to plan (e.g., 'user authentication' or point to a requirements file)"
---

The user wants to plan: **$INPUT**

## Precondition

Requirements MUST exist in `.co-agents/requirements/`. If they don't, stop and tell the user to run `/co-specify` first.

## Workflow

1. Read the requirements document for this feature
2. Read `decisions.md` for architectural constraints
3. Scan the codebase for existing conventions and patterns
4. **Produce a task file** in `.co-agents/tasks/{feature}-tasks.md`

## Task Rules

- Organize by **user story**, not technical layer
- Choose a short prefix (3-4 uppercase letters) from the feature name (e.g., `auth` → `AUTH`, `orders` → `ORD`)
- Prefixed sequential IDs (`{PREFIX}-001`, `{PREFIX}-002`, ...) for globally unique traceability
- Mark parallelizable tasks with `[P]`
- Every task: REQ-ID reference, testable acceptance criteria, complexity (S/M/L)
- Flag `Approach: TDD` for complex logic, domain invariants, critical correctness
- Split anything larger than L

## Quality Gates

- **Simplicity gate**: Flag tasks introducing unnecessary abstractions — "Is this the simplest thing that could work?"
- **Anti-abstraction gate**: Flag one-time helpers — "Will this be used more than once?"
- Every requirement has at least one task covering it
- Dependencies form a valid DAG (no cycles)

End with a summary: total tasks, TDD count, parallel count, complexity distribution, suggested starting point.

## Done When

Task file is saved. Then suggest `/co-analyze` to verify consistency, then `/co-implement` to start building.
