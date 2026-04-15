# Co-Agents

A structured SDLC workflow for GitHub Copilot — 4 specialized agents, 11 prompts, and a persistent project memory system that turns Copilot into a full development team.

## Quick Start

Install into your project directory:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mohamed-abdelsamei/co-agents/main/remote-install.sh) .
```

For private repos, add `--ssh`. See [install options](#install-options) for more.

Then:

1. Edit `.github/copilot-instructions.md` to define your stack (languages, frameworks, infrastructure)
2. Run `/co-init` to scan the codebase, populate project memory, and define principles

## Agents

| Agent | Role |
|-------|------|
| `@architect` | Requirements, architecture, task planning, code review, strategic advice, git commits for docs/plans |
| `@engineer` | Implementation, debugging, TDD, experiments, demos, git branching and commits |
| `@devops` | CI/CD, infrastructure-as-code, deployment, monitoring |
| `@researcher` | Research, comparisons, documentation |

## Workflow

```
/co-setup or /co-init → /co-spec → /co-plan → /co-build → /co-review
```

Research (`/co-research`), documentation (`/co-docs`), advisory (`/co-advise`), and infrastructure (`/co-deploy`) can be used at any phase.

**Refinement loop:**

```
/co-spec (refine mode) → /co-plan → /co-build → /co-review
```

**Experiment fast-track:**

```
/co-build (experiment mode) → (success?) → /co-spec → full SDLC
```

## Prompts

| What You Need | Prompt | Agent |
|---------------|--------|-------|
| Set up a new project — constitution + stack config | `/co-setup` | `@architect` |
| Onboard existing project + define principles | `/co-init` | `@architect` |
| Gather, clarify, or refine requirements | `/co-spec` | `@architect` |
| Plan & break into tasks + consistency check | `/co-plan` | `@architect` |
| Implement features, experiments, or demos | `/co-build` | `@engineer` |
| Report & fix a bug | `/co-fix` | `@engineer` |
| Review implementation | `/co-review` | `@architect` |
| Strategic advice or feature assessment | `/co-advise` | `@architect` |
| Research a topic | `/co-research` | `@researcher` |
| Write documentation | `/co-docs` | `@researcher` |
| Infrastructure / CI/CD / deployment | `/co-deploy` | `@devops` |

## What Gets Installed

```
your-project/
├── .github/
│   ├── agents/           4 agent definitions
│   ├── prompts/          11 prompt workflows
│   ├── instructions/     Shared standards (agent, code quality, memory, templates)
│   ├── skills/           Workflow skills (co-memory)
│   └── copilot-instructions.md
├── docs/                 Primary source of truth (architecture, research, specs)
│   └── README.md
└── .co-agents/           Project memory skeleton
    ├── constitution.md
    ├── decisions.md
    ├── architecture.md
    ├── improvements.md
    ├── requirements/
    ├── tasks/
    ├── reviews/
    ├── research/
    └── experiments/
```

## Code Quality

The framework enforces clean, maintainable code through rules baked into the `@engineer` and `@architect` agents:

| Rule | Enforced By |
|------|-------------|
| **Single Responsibility** — each function does one thing | `@engineer` (decompose before writing) + `@architect` (review structural check) |
| **Small functions** — prefer ~20 lines max, split longer ones into helpers | `@engineer` (self-review gate) + `@architect` (flags oversized functions) |
| **Shallow nesting** — max 2-3 levels, use early returns and guard clauses | `@engineer` + `@architect` |
| **Focused files** — split when a file covers multiple concerns | `@engineer` + `@architect` |
| **TDD** — write failing tests first for tasks marked `Approach: TDD` | `@engineer` (strict compliance) |
| **Constitution enforcement** — principles from `constitution.md` are non-negotiable | `@engineer` (checks before coding) + `@architect` (alignment check) |
| **Security scans** — run on every new or modified code | `@engineer` (after coding) + `@architect` (verification) |

Customize thresholds and add language-specific rules in `.github/copilot-instructions.md`.

## Git Conventions

Both `@architect` and `@engineer` use git to track their work:

| Convention | Details |
|------------|--------|
| **Branch naming** | `feat/`, `fix/`, `spike/` (engineer) · `docs/`, `plan/` (architect) |
| **Commit messages** | Conventional commits — `feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:` |
| **Atomic commits** | One logical change per commit, committed after each completed task or TDD cycle |
| **No secrets** | Never commit credentials or environment-specific config |

## Auto-Continue

The `@engineer` implements tasks continuously without stopping between each one. After completing a task, it automatically picks the next unblocked task in the same phase (`##` section in the task file). It only stops when:

- All tasks in the phase are done (suggests `/co-review`)
- Next task is blocked by unmet prerequisites
- A task fails compilation/tests after 2 attempts
- A requirement is ambiguous

This means you can run `/co-build all auth tasks` and walk away — the engineer will work through the entire phase autonomously.

## Agent Feedback Loops

Agents share context through `.co-agents/` so nothing falls through the cracks:

| Loop | How It Works |
|------|--------------|
| **Tech debt → Planning** | `@engineer` logs tech debt in `improvements.md` → `@architect` reads it during `/co-plan` |
| **Review → Fix tasks** | `@architect` appends fix tasks directly to the task file → `/co-build` picks them up |
| **Review prerequisites** | `/co-review` verifies tasks are done before reviewing — won't run on unimplemented code |
| **Infra alignment** | `@devops` follows architecture decisions from `docs/` and `decisions.md` |
| **Refinement cascade** | `/co-spec` (refine mode) rewrites requirements → marks affected tasks `[!]` (re-verify) or `[obsolete]` → `/co-build` picks up clean plan |

## Project Memory

Every decision, requirement, and review is tracked in `.co-agents/` — committed to version control so context is never lost. `docs/` is the primary source of truth for architecture and specs; `.co-agents/` tracks operational artifacts.

| Directory | Contents |
|-----------|----------|
| `constitution.md` | Non-negotiable principles and quality gates |
| `decisions.md` | Append-only architecture decision records |
| `architecture.md` | System architecture overview |
| `improvements.md` | Tech debt and improvement backlog |
| `requirements/` | One file per feature — testable requirements |
| `tasks/` | Implementation plans broken into tracked tasks |
| `reviews/` | Structured review reports with verdicts |
| `research/` | Research findings and analysis |
| `experiments/` | Spike findings and demo scripts |

## Install Options

| Flag | Description |
|------|-------------|
| `--dry-run` | Preview without making changes |
| `--force` | Overwrite existing files |
| `--no-memory` | Skip `.co-agents/` skeleton |
| `--ssh` | Clone via SSH (private repos) |

**From a local clone:**

```bash
git clone https://github.com/mohamed-abdelsamei/co-agents.git
cd co-agents
./install.sh ~/path/to/your-project
```

## Contributing

| What | Where |
|------|-------|
| Agent definitions | `.github/agents/` |
| Prompt workflows | `.github/prompts/` |
| Skills | `.github/skills/{name}/SKILL.md` |
| Memory templates | `.github/instructions/memory.instructions.md` |
