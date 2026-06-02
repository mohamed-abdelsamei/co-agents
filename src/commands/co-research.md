---
description: "Research a topic, technology, library, or pattern — produces a structured summary with findings, comparisons, and recommendations."
agent: researcher
argument-hint: "Topic to research (e.g., 'state management in Flutter' or 'comparing ORMs for Node.js')"
---

The user wants to research: **$INPUT**

## Before You Start

1. **Frame the question** — Restate it as a research question and break it into sub-questions. If it's too broad to start, ask 1-3 scoping questions.
2. **Read what we already know** — Scan `.co-agents/research/` (including `README.md`, the knowledge index) and, if the research is for planned work, the relevant `requirements/`. If a document already covers this topic, treat this as a **research update** — load it and revise in-place rather than creating a new file.

## What to Deliver

- A full research document saved to `.co-agents/research/{topic}.md` using the research template (update in-place if one exists).
- **Update the knowledge index** `.co-agents/research/README.md` — add/refresh the topic row, "What We Know", and "Open Questions".
- Every finding backed by a dated source and marked with a confidence level; conflicting sources surfaced, not hidden; every recommendation with rationale.
- If comparing options, use measurable criteria in a comparison table.
- If the work produces durable reference material (an API/config reference, a guide), also publish a polished version to `docs/`.

## Source Discipline

Prefer primary/official sources. Record source dates. Flag anything that may be stale or past your knowledge cutoff. Never present an unverified claim as fact.

## Scope Guard

Research only. Do not write implementation code or make architecture/requirements decisions. If research points to a decision, capture it in the document's **Decision Impact** section and suggest recording an ADR via `/co-advise`.

## Done When

The research document and the knowledge index are saved, with dated findings, confidence levels, and a clear recommendation. Suggest `/co-spec` if the research implies a feature, or `/co-advise` to turn a recommendation into a recorded decision.
