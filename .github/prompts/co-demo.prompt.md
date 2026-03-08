---
description: "Prepare a demo — define goals, build minimal working code, create a step-by-step demo script."
agent: engineer
argument-hint: "What to demo (e.g., 'multi-service deployment' or 'auth flow end-to-end')"
---

The user wants to prepare a demo for: **$INPUT**

## This Is Demo Preparation

Build a minimal, working demonstration with a rehearsed script. Smooth walkthrough > production code.

## Workflow

1. **Define goals** — What to demonstrate, who's the audience, key takeaway.
2. **Build minimal demo** — Just enough to show the concept. Hardcoded data is fine.
3. **Create demo script** — Save to `.co-agents/experiments/{name}-demo.md`. Include: setup, talking points per step, expected outputs, fallback plan.
4. **Dry run** — Execute the full script. Fix rough edges.

## Done When

Demo script is saved and dry run is successful. If the concept should become a feature, suggest `/co-specify`.
