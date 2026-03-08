---
description: "Cross-check requirements, tasks, and decisions for consistency gaps before implementation."
agent: reviewer
argument-hint: "Name the feature to analyze, or leave blank to check everything"
---

The user wants to analyze consistency for: **$INPUT**

## This Is a Cross-Artifact Analysis

Check that requirements, tasks, decisions, and constitution are consistent. **Read-only** diagnostic — produce a findings report, nothing else.

## Precondition

Requirements AND tasks must exist. If both are missing, stop and suggest `/co-specify` and `/co-plan`.

## What to Check

- **Requirements ↔ Tasks**: Every REQ-ID has a task; every task references a valid REQ-ID
- **Tasks ↔ Decisions**: Tasks don't contradict architectural decisions
- **Requirements ↔ Constitution**: Requirements respect stated principles
- **Cross-cutting**: Terminology drift, implicit assumptions, circular task dependencies

## What to Deliver

Save analysis to `.co-agents/reviews/{feature}-analysis.md` with: coverage summary table, categorized findings (critical/warning/info), recommendation.

## Done When

Analysis report is saved. If fixes are needed, suggest `/co-specify` (requirements gaps), `/co-plan` (task gaps), or `/co-implement` (implementation gaps).
