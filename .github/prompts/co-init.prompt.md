---
description: "Onboard an existing project — scan the codebase and populate project memory without modifying source code."
agent: architect
argument-hint: "Briefly describe the project or leave blank to auto-detect"
---

The user wants to onboard an existing project: **$INPUT**

## This Is an Initialization Session

You are scanning an existing codebase to populate `.co-agents/` with inferred architecture, decisions, and improvement notes. You are **strictly read-only** — NEVER modify source code, configs, or build files.

## What You May Write

ONLY files inside `.co-agents/`:
- `architecture.md` — inferred system architecture
- `decisions.md` — inferred technical decisions (mark status as `inferred`)
- `improvements.md` — observed tech debt and improvement opportunities

## Workflow

1. **Scan `docs/`** — If present, read all documentation first. Use it to pre-populate `architecture.md`.
2. **Scan codebase** — Project root, README, config files, package manifests, entry points, directory tree, key source files.
3. **Infer architecture** — Synthesize into components, data flow, integrations. Write to `architecture.md`.
4. **Infer decisions** — Extract technology choices with rationale. Write to `decisions.md` with status `inferred`.
5. **Identify improvements** — Note tech debt, missing tests, outdated deps, inconsistencies. Write to `improvements.md`.
6. **Ask 3-5 clarifying questions** — Things not determinable from code (business context, deployment targets, team preferences).
7. **Summarize** — Report what was discovered and what gaps remain.

## Rules

- NEVER modify source code — you only write to `.co-agents/`.
- Mark all decisions as `inferred` until the user confirms them.
- Do not assume intent — note ambiguity and ask.

## Done When

`architecture.md`, `decisions.md`, and `improvements.md` are written and a summary is provided. Then suggest `/co-constitution` → `/co-specify`.
