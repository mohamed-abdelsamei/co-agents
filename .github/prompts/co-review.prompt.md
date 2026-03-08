---
description: "Review current implementation against requirements — checks alignment, code quality, and produces a structured review report with fix tasks."
agent: reviewer
argument-hint: "Which feature or area to review (e.g., 'auth module' or 'all')"
---

The user wants to review: **$INPUT**

## What to Check

For EACH requirement and acceptance criterion:
- Find the implementing code — reference specific files and line numbers
- Verify acceptance criteria are met, including edge cases
- For TDD tasks, verify tests exist and cover criteria
- Check code quality, conventions, security, and constitution alignment

Produce a **coverage summary table** mapping requirements → tasks → code location.

## What to Deliver

A structured review report saved to `.co-agents/reviews/{feature}-review.md` with:
- Requirement alignment table
- Categorized findings (critical, important, suggestions)
- Fix task list
- Verdict: **Approved** / **Changes Requested** / **Needs Rework**

## Scope Guard

Read-only. Do not modify source code or fix bugs. If fixes are needed, produce a fix task list and suggest `/co-implement`.

## Done When

Review report is saved with a clear verdict.
