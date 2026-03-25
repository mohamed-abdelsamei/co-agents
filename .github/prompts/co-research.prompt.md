---
description: "Research a topic, technology, library, or pattern — produces a structured summary with findings, comparisons, and recommendations."
agent: researcher
argument-hint: "Topic to research (e.g., 'state management in Flutter' or 'comparing ORMs for Node.js')"
---

The user wants to research: **$INPUT**

## Before You Start

1. Check both `.co-agents/research/` AND `docs/` for existing coverage of this topic. If a document already exists, treat this as a **research update** — load the existing document, identify what's outdated or missing, and update in-place rather than creating a new file.
2. If the topic is vague, ask 1-3 scoping questions first

## What to Deliver

- A structured research summary saved to `docs/` (update existing file if one was found) with an index entry in `.co-agents/research/` (update existing entry if one was found)
- Every finding backed by a source; every recommendation with rationale
- If comparing options, use measurable criteria in a comparison table

## Scope Guard

Research only. Do not write implementation code or make architecture decisions. If the request implies those, complete the research and suggest `/co-specify` or `/co-plan`.

## Done When

Research document is saved with findings, comparisons (if applicable), and a clear recommendation.
