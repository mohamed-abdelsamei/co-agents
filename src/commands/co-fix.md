---
description: "Report and fix a bug — creates a tracked task, diagnoses the issue, and applies a minimal fix with regression test."
agent: engineer
argument-hint: "Describe the bug (e.g., 'API returns 500 on empty input' or 'login page crashes after timeout')"
---

The user is reporting a bug: **$INPUT**

## This Is a Bug Tracking + Fix Session

Create a tracked task for the bug, then diagnose and fix it.

## Step 1: Gather Details

Ask up to 3 clarifying questions if needed:
- What is the expected behavior vs actual behavior?
- Steps to reproduce?
- Which feature area is affected?

## Step 2: Create Bug Task

Determine which feature's task file this belongs to (check `.co-agents/tasks/`). If none exists, create `.co-agents/tasks/bugs-tasks.md`.

Add a bug task entry using the feature's prefix (or `BUG` if standalone):

```markdown
- [ ] **{PREFIX}-{NNN}** — Fix: {short description}
  - **Reported**: YYYY-MM-DD
  - **Severity**: critical | high | medium | low
  - **Symptoms**: {what the user observes}
  - **Reproduction**: {steps to reproduce}
  - **Root cause**: (to be filled after diagnosis)
  - **Complexity**: S | M | L
  - **Acceptance**: {specific criteria for "fixed" + regression test}
```

## Step 3: Diagnose and Fix

1. **Reproduce** — Confirm the bug
2. **Isolate** — Narrow down the cause
3. **Root-cause** — Update the task with root cause
4. **Fix** — Minimal fix addressing root cause
5. **Verify** — Confirm fix, write regression test
6. **Mark done** — Set task to `[x]`

## Done When

Bug task is created, root cause documented, fix applied, regression test written, task marked `[x]`.
