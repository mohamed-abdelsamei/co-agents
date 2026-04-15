---
description: "Plan implementation — break requirements into phased tasks with dependencies, then verify consistency."
agent: architect
argument-hint: "Feature to plan (e.g., 'user authentication' or point to a requirements file)"
---

The user wants to plan: **$INPUT**

## Precondition

Requirements MUST exist in `.co-agents/requirements/`. If they don't, stop and tell the user to run `/co-spec` first.

## Workflow

1. Read the requirements document for this feature
2. Read `decisions.md` for architectural constraints
3. Scan the codebase for existing conventions and patterns
4. **Check for existing tasks** — If `.co-agents/tasks/{feature}-tasks.md` already exists, load it. Update and add tasks rather than recreating from scratch. **Preserve completed task statuses** (`[x]`) — never reset done tasks. Remove tasks marked `[obsolete]`. Re-evaluate tasks marked `[!]` (needs re-verification) — update their acceptance criteria to match revised requirements, then reset to `[ ]` if re-implementation is needed or `[x]` if the existing code still matches.
5. **Produce or update the task file** in `.co-agents/tasks/{feature}-tasks.md`

## Task Rules

- Organize by **user story**, not technical layer — each `##` heading in the task file defines a **phase** that the engineer auto-continues through
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

## Consistency Analysis (auto-runs after task generation)

After producing the task file, automatically verify:
1. Every REQ-ID has a corresponding task; every task references a valid REQ-ID
2. Tasks don't contradict architectural decisions
3. Requirements respect constitution principles
4. No terminology drift, implicit assumptions, or circular dependencies
5. Flag under-scoped or technically risky tasks

If issues found, output analysis to `.co-agents/reviews/{feature}-analysis.md` and note them in the summary.

End with a summary: total tasks, TDD count, parallel count, complexity distribution, consistency check result, suggested starting point.

## Done When

Task file is saved and consistency verified. Then suggest `/co-build` to start building.
