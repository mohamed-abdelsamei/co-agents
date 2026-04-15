---
description: "Set up a new project — define constitution, configure copilot-instructions.md, and initialize project memory."
agent: architect
argument-hint: "Describe the project, its stack, and goals"
---

The user wants to set up a new project: **$INPUT**

## This Is a Project Setup Session

You are helping define the foundational rules and configuration for a **new** project. Unlike `/co-init` (which scans an existing codebase), this prompt starts from the user's intent and builds the project's constitution and instructions from scratch.

## What You May Write

- `.co-agents/constitution.md` — project principles and quality gates
- `.github/copilot-instructions.md` — **only** the `Language & Stack Focus` and `Code Quality` sections (preserve everything else)
- `.co-agents/decisions.md` — log setup decisions

## Workflow

### Phase 1: Discover Intent

1. **Parse input** — Extract project name, purpose, stack, and constraints from `$INPUT`.
2. **Ask structured questions** — Up to 3 batches of 3-5 questions covering:
   - **Stack**: Languages, frameworks, runtime targets, package managers
   - **Quality**: Testing strategy (TDD? coverage targets?), linting, formatting
   - **Security**: Auth model, input validation rules, data handling constraints
   - **Conventions**: File naming, commit format, branching strategy, code style
   - **Constraints**: Minimum versions, deployment targets, compliance requirements
   - **Governance**: Who approves architecture changes? Exception process?
3. **Scan for existing files** — If `.co-agents/constitution.md` or `.github/copilot-instructions.md` already have content, present them for review instead of overwriting blindly.

### Phase 2: Produce Constitution

4. **Write constitution** — Save to `.co-agents/constitution.md` using the template from memory standards. Include:
   - Project identity (name, purpose, primary stack)
   - Principles (quality, testing, security, conventions)
   - Technical constraints
   - Governance rules
5. **Mark unresolved areas** — Tag anything uncertain with `[NEEDS CONFIRMATION]` and `status: draft`.

### Phase 3: Configure Instructions

6. **Update `copilot-instructions.md`** — Set the `Language & Stack Focus` section:
   - **Languages**: from user's answers
   - **Frameworks**: from user's answers
   - **Infrastructure**: from user's answers (or `(none yet)` if not discussed)
   - Add language-specific rules under `Code Quality` if the user specified any
7. **Preserve existing sections** — Do NOT modify `Routing`, `Docs Folder`, `Project Memory`, or `Agent Team & Prompts` sections.

### Phase 4: Record & Summarize

8. **Log decision** — Append a "Project setup" entry to `decisions.md`.
9. **Summarize** — Show what was created:
   - Constitution highlights (principles, constraints, conventions)
   - Stack configuration
   - Any `[NEEDS CONFIRMATION]` items to revisit
10. **Suggest next step** — `/co-spec` to begin defining the first feature.

## Rules

- Maximum **3 question rounds**. After round 3, produce documents with best understanding.
- Do NOT create source code, build configs, or project scaffolding — this prompt defines rules, not code.
- Do NOT modify routing, memory, or agent sections of `copilot-instructions.md`.
- If the user provides enough info in `$INPUT`, skip redundant questions and go straight to producing documents.
- If a constitution already exists with `status: active`, warn before overwriting.

## Done When

`constitution.md` is written, `copilot-instructions.md` stack section is configured, and a summary is provided. Then suggest `/co-spec` to define the first feature.
