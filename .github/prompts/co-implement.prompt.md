---
description: "Implement a task or feature, or debug an issue — writes code following requirements, uses TDD for complex work."
agent: engineer
argument-hint: "Task to implement or bug to fix (e.g., 'task T003 from auth-tasks' or 'fix: API returns 500 on empty input')"
---

The user wants to implement: **$INPUT**

## Mode Detection

If the input describes a **bug, error, or issue** → switch to **Debug Mode** below.
Otherwise → continue with **Implementation Mode**.

## Implementation Mode

1. Read the task from `.co-agents/tasks/` — identify the target task (or first unblocked task if a phase/feature is given). **Skip** tasks marked `[obsolete]`.
2. If task is marked `[!]` (needs re-verification) — read the revised requirement, check if existing implementation still matches. If valid, mark `[x]` and move on. If not, re-implement.
3. Read linked requirements from `.co-agents/requirements/` — skip any marked `obsolete`
4. Verify prerequisite tasks are marked `[x]` done
4. If task is `Approach: TDD` — write the failing test FIRST
5. Implement following project conventions
6. Structure check — refactor any function exceeding ~20 lines or with multiple responsibilities
7. Verify code compiles and tests pass
8. Run security scan on new or modified code
9. Mark task `[x]` done in tasks file
10. Brief status line: task ID, what changed, tests written
11. **Auto-continue**: Pick the next unblocked task in the same phase and repeat from step 1. Stop only when:
    - All tasks in the phase are done → suggest `/co-review`
    - Next task is blocked (unmet prerequisites)
    - A task fails after 2 attempts
    - A requirement is ambiguous — flag and stop

If no tasks exist, stop and suggest `/co-specify` → `/co-plan` first.

## Debug Mode

1. **Reproduce** — Confirm the bug. Get exact steps, expected vs actual behavior.
2. **Isolate** — Narrow down using logs, breakpoints, binary search. Check recent changes.
3. **Root-cause** — Understand WHY, not just WHERE.
4. **Fix** — Minimal fix addressing root cause. No unrelated refactoring.
5. **Verify** — Confirm fix works. Write regression test.
6. **Document** — Note systemic issues in `improvements.md`.

## Scope Guard

Implement exactly what requirements specify. If a requirement seems wrong, STOP and flag it — do not silently deviate.

## Done When

**Implementation**: Task marked `[x]` done and tests pass. When all tasks in a phase are complete, suggest `/co-review`.
**Debug**: Bug is fixed, regression test written, fix verified.
