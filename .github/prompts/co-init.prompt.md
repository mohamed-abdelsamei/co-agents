---
description: "Onboard an existing project — scan the codebase, populate project memory, and define principles."
agent: architect
argument-hint: "Briefly describe the project or leave blank to auto-detect"
---

The user wants to onboard an existing project: **$INPUT**

## This Is an Initialization Session

You are scanning an existing codebase to populate `.co-agents/` with inferred architecture, decisions, improvement notes, and project principles. You are **strictly read-only** on source code — NEVER modify source code, configs, or build files.

## What You May Write

ONLY files inside `.co-agents/`:
- `architecture.md` — inferred system architecture
- `decisions.md` — inferred technical decisions (mark status as `inferred`)
- `improvements.md` — observed tech debt and improvement opportunities
- `constitution.md` — project principles and quality gates

## Workflow

### Phase 1: Codebase Scan

1. **Scan `docs/`** — If present, read all documentation first. Use it to pre-populate `architecture.md`.
2. **Scan codebase** — Project root, README, config files, package manifests, entry points, directory tree, key source files.
3. **Infer architecture** — Synthesize into components, data flow, integrations. Write to `architecture.md`.
4. **Infer decisions** — Extract technology choices with rationale. Write to `decisions.md` with status `inferred`.
5. **Identify improvements** — Note tech debt, missing tests, outdated deps, inconsistencies. Write to `improvements.md`.

### Phase 2: Project Principles

6. **Check existing constitution** — If `.co-agents/constitution.md` already has content, present it for review instead of starting fresh.
7. **Scan for conventions** — Infer from codebase: linting configs, test frameworks, code style, naming patterns.
8. **Ask about principles** — Up to 3 batches of questions (3-5 each) covering: quality standards, security rules, technical constraints, conventions, governance.
9. **Produce constitution** — Save to `.co-agents/constitution.md`. Mark unresolved areas with `[NEEDS CONFIRMATION]`.
10. **Record decision** — Log constitution creation in `decisions.md`.

### Phase 3: Summary

11. **Summarize** — Report what was discovered and what gaps remain.

## Rules

- NEVER modify source code — you only write to `.co-agents/`.
- Mark all decisions as `inferred` until the user confirms them.
- Mark inferred principles as `inferred` for user confirmation.
- Do not assume intent — note ambiguity and ask.
- Maximum **3 question rounds** total across both phases. After round 3, produce documents with best understanding.

## Done When

`architecture.md`, `decisions.md`, `improvements.md`, and `constitution.md` are written and a summary is provided. Then suggest `/co-spec` to begin defining features.
