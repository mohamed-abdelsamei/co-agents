# Project Documentation

`docs/` holds the project's **durable, human-facing source-of-truth documents**:
the architecture overview, design specs, API references, and guides. It is
committed to the repo alongside `.co-agents/`.

Each artifact has **exactly one home** — `docs/` and `.co-agents/` do not keep
duplicate copies of the same thing.

## What goes here

- `architecture.md` — the architecture overview (single home; not duplicated in `.co-agents/`)
- Design specs and RFCs
- API references, guides, and explanations (e.g. from `/co-docs`)

## What does NOT go here

Operational memory lives in `.co-agents/` instead: decisions, requirements,
tasks, reviews, **research findings** (`.co-agents/research/`), and experiments.

## How it gets populated

- `/co-init` — writes the inferred `architecture.md`
- `/co-docs` — saves reference docs, explanations, and specs here
- `/co-advise` — saves tradeoff analyses here
- Manual additions — your own architecture docs, RFCs, or specs

## `docs/` vs `.co-agents/`

| `docs/` | `.co-agents/` |
|---------|---------------|
| Architecture, specs, guides, API refs | Constitution, decisions, requirements, tasks, reviews, research, experiments |
| Durable source-of-truth documents | Operational/working memory |
| Source of truth for **architecture & specs** | Source of truth for **project memory & workflow state** |
