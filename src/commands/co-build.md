---
description: "Implement tasks, run experiments, or prepare demos — writes code following requirements, uses TDD for complex work."
agent: engineer
argument-hint: "Task to implement, spike to run, or demo to prepare (e.g., 'AUTH-001' or 'spike: WebSocket perf' or 'demo: auth flow')"
---

The user wants to build: **$INPUT**

## Mode Detection

- If the input mentions **experiment, spike, hypothesis, or test an idea** → **Experiment Mode** below
- If the input mentions **demo, walkthrough, or showcase** → **Demo Mode** below
- If the input describes a **bug, error, or issue** → **Debug Mode** below
- Otherwise → **Implementation Mode** below

## Implementation Mode

1. Read the task from `.co-agents/tasks/` — identify the target task (or first unblocked task if a phase/feature is given). **Skip** tasks marked `[obsolete]`.
2. If task is marked `[!]` (needs re-verification) — read the revised requirement, check if existing implementation still matches. If valid, mark `[x]` and move on. If not, re-implement.
3. Read linked requirements from `.co-agents/requirements/` — skip any marked `obsolete`
4. Verify prerequisite tasks are marked `[x]` done
5. If task is `Approach: TDD` — write the failing test FIRST
6. Implement following project conventions
7. Structure check — refactor any function exceeding ~20 lines or with multiple responsibilities
8. Verify code compiles and tests pass
9. Run security scan on new or modified code
10. Mark task `[x]` done in tasks file
11. Brief status line: task ID, what changed, tests written
12. **Auto-continue**: Pick the next unblocked task in the same phase and repeat from step 1. Stop only when:
    - All tasks in the phase are done → suggest `/co-review`
    - Next task is blocked (unmet prerequisites)
    - A task fails after 2 attempts
    - A requirement is ambiguous — flag and stop

If no tasks exist, stop and suggest `/co-spec` → `/co-plan` first.

## Experiment Mode

Time-boxed spike to answer a specific question. Skip the full SDLC pipeline.

1. **Define hypothesis** — Turn input into a testable statement. If too vague, ask one clarifying question.
2. **Set boundaries** — What to build, what to measure, max time investment.
3. **Spike** — Build minimal code. Fast path: scaffolding, boilerplate, copy-paste from docs. No gold-plating.
4. **Observe** — Run it. Note what works, what's surprising, gotchas.
5. **Document** — Save findings to `.co-agents/experiments/{name}.md`.

If it succeeds and should become a feature, suggest `/co-spec` → `/co-plan` → `/co-build`.

## Demo Mode

Build a minimal, working demonstration with a rehearsed script.

1. **Define goals** — What to demonstrate, who's the audience, key takeaway.
2. **Build minimal demo** — Just enough to show the concept. Hardcoded data is fine.
3. **Create demo script** — Save to `.co-agents/experiments/{name}-demo.md`. Include: setup, talking points per step, expected outputs, fallback plan.
4. **Dry run** — Execute the full script. Fix rough edges.

If the concept should become a feature, suggest `/co-spec`.

## Debug Mode

1. **Reproduce** — Confirm the bug. Get exact steps, expected vs actual behavior.
2. **Isolate** — Narrow down using logs, breakpoints, binary search. Check recent changes.
3. **Root-cause** — Understand WHY, not just WHERE.
4. **Fix** — Minimal fix addressing root cause. No unrelated refactoring.
5. **Verify** — Confirm fix, write regression test.
6. **Document** — Note systemic issues in `improvements.md`.

## Scope Guard

Implement exactly what requirements specify. If a requirement seems wrong, STOP and flag it — do not silently deviate.

## Done When

**Implementation**: Task marked `[x]` done and tests pass. When all tasks in a phase are complete, suggest `/co-review`.
**Experiment**: Findings documented with a clear verdict (confirmed / partially confirmed / rejected).
**Demo**: Demo script saved and dry run successful.
**Debug**: Bug fixed, regression test written, fix verified.
