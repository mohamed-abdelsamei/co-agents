# Project Documentation

This folder is the **primary source of truth** for architecture, research, and specs.

Agents scan `docs/` before every task. When `docs/` and `.co-agents/` disagree, `docs/` wins.

## What goes here

- Architecture documents and design specs
- Research summaries and technology comparisons  
- API references and guides
- Any documentation produced by `@researcher` via `/co-research` or `/co-document`

## How it gets populated

- `/co-research` — saves research summaries here
- `/co-document` — saves reference docs, explanations, and specs here
- `/co-advise` — saves tradeoff analyses here
- Manual additions — add your own architecture docs, RFCs, or specs

## Relationship to `.co-agents/`

| `docs/` | `.co-agents/` |
|---------|---------------|
| Architecture specs, research, guides | Operational tracking (tasks, requirements, reviews) |
| Written by humans and `@researcher` | Written by all agents |
| Source of truth on conflicts | Tracks workflow state |
