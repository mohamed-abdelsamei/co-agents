---
description: "Run a quick experiment or spike — define a hypothesis, build minimal code, and document findings."
agent: engineer
argument-hint: "What to test (e.g., 'can we use WebSockets for real-time sync' or 'does library X handle 10k concurrent connections')"
---

The user wants to experiment with: **$INPUT**

## This Is a Spike — Not a Feature

Time-boxed experiment to answer a specific question. Skip the full SDLC pipeline.

## Workflow

1. **Define hypothesis** — Turn input into a testable statement. If too vague, ask one clarifying question.
2. **Set boundaries** — What to build, what to measure, max time investment.
3. **Spike** — Build minimal code. Fast path: scaffolding, boilerplate, copy-paste from docs. No gold-plating.
4. **Observe** — Run it. Note what works, what's surprising, gotchas.
5. **Document** — Save findings to `.co-agents/experiments/{name}.md`.

## Scope Guard

This is throwaway code. If it succeeds and should become a feature, suggest `/co-specify` → `/co-plan` → `/co-implement`.

## Done When

Experiment findings are documented with a clear verdict (confirmed / partially confirmed / rejected).
