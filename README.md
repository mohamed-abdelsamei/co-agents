# Co-Agents

A reusable **agent team** that takes a project from **research and planning through implementation, review, and ops** — running in both **Claude Code** and **GitHub Copilot**. Four specialized agents, 11 `/co-*` commands, and a persistent, version-controlled **project memory** (decisions, requirements, tasks, and a research knowledge base) so context and rationale are never lost between sessions.

It's built for more than shipping code: research is a first-class phase with sourced, confidence-rated findings and a living knowledge index, and planning has a lightweight mode for exploratory or non-code work.

The same agents, commands, and conventions are authored once in `src/` and generated into each tool's **native** distribution format — a plugin for Claude Code, `.github/` files for GitHub Copilot. Adding another editor is one adapter.

## Quick Start

### Claude Code (plugin)

```
/plugin marketplace add mohamed-abdelsamei/co-agents
/plugin install co-agents
```

Then, inside your project, run `/co-setup` (new project) or `/co-init` (existing project) — the command creates `.co-agents/`, `docs/`, and `CLAUDE.md` for you.

### GitHub Copilot (file install)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mohamed-abdelsamei/co-agents/main/remote-install.sh) .
```

For private repos, add `--ssh`. See [install options](#install-options) for more. Then:

1. Edit `.github/copilot-instructions.md` to define your stack (languages, frameworks, infrastructure)
2. Run `/co-init` to scan the codebase, populate project memory, and define principles

## Agents

| Agent | Role |
|-------|------|
| `@architect` | Requirements, architecture, task planning (incl. lightweight/non-code), code review, strategic advice |
| `@engineer` | Implementation, debugging, TDD, experiments, demos |
| `@devops` | CI/CD, infrastructure-as-code, deployment, monitoring |
| `@researcher` | Evidence-based research with a living knowledge base, technology comparisons, and documentation |

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

**Claude Code** — installs the plugin (agents, commands, skills) into Claude's plugin cache; nothing is copied into your repo. Running `/co-setup` or `/co-init` then bootstraps the project files:

```
your-project/          (created on first /co-setup or /co-init)
├── CLAUDE.md           Main instructions (routing, project memory, stack)
├── docs/               Durable source of truth — architecture.md, specs, guides
└── .co-agents/         Operational project memory (see below)
```

**GitHub Copilot** — the installer copies files into your repo:

```
your-project/
├── .github/
│   ├── agents/           4 agent definitions
│   ├── prompts/          11 prompt workflows
│   ├── instructions/     Shared standards (auto-applied via applyTo)
│   ├── skills/           Workflow skills (co-memory)
│   └── copilot-instructions.md
├── docs/                 Durable source of truth
│   ├── README.md
│   └── architecture.md   Architecture overview (single home)
└── .co-agents/           Operational project memory
    ├── constitution.md
    ├── decisions.md
    ├── improvements.md
    ├── requirements/  tasks/  reviews/  research/  experiments/
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

All agents use git to track their work (`@architect`/`@engineer` for code and plans, `@researcher` for docs/research, `@devops` for infrastructure):

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

Every decision, requirement, and review is tracked in `.co-agents/` — committed to version control so context is never lost. Both `docs/` and `.co-agents/` are committed, with **one home per artifact** (no duplication): `docs/` holds durable source-of-truth documents; `.co-agents/` holds operational memory.

| Location | Contents |
|----------|----------|
| `docs/architecture.md` | Architecture overview — single home |
| `docs/` (other) | Design specs, API references, guides |
| `.co-agents/constitution.md` | Non-negotiable principles and quality gates |
| `.co-agents/decisions.md` | Append-only architecture decision records |
| `.co-agents/improvements.md` | Tech debt and improvement backlog |
| `.co-agents/requirements/` | One file per feature — testable requirements |
| `.co-agents/tasks/` | Implementation plans broken into tracked tasks |
| `.co-agents/reviews/` | Structured review reports with verdicts |
| `.co-agents/research/` | Research findings (sourced, confidence-rated) + `README.md` knowledge index |
| `.co-agents/experiments/` | Spike findings and demo scripts |

## Install Options

The `install.sh` / `remote-install.sh` file installer is for **GitHub Copilot** (Claude Code uses the plugin marketplace — see [Quick Start](#quick-start)).

| Flag | Description |
|------|-------------|
| `--claude` | Print the Claude Code plugin install steps, then exit |
| `--copilot` | Install the GitHub Copilot layout (`.github/`) — the default |
| `--dry-run` | Preview without making changes |
| `--force` | Overwrite existing files |
| `--no-memory` | Skip `.co-agents/` skeleton |
| `--ssh` | Clone via SSH (private repos, `remote-install.sh` only) |

**From a local clone:**

```bash
git clone https://github.com/mohamed-abdelsamei/co-agents.git
cd co-agents
./install.sh ~/path/to/your-project        # GitHub Copilot
```

## Contributing

Everything is authored **once** in `src/` (Copilot dialect) and generated into each tool's native artifact under `dist/` by the adapter build. Edit `src/`, never `dist/`, and commit the regenerated `dist/`.

```bash
python3 scripts/build.py                 # build all targets
python3 scripts/build.py claude          # build one target
python3 scripts/build.py --check         # CI guard: fail if dist/ is stale
```

| What | Where (edit in `src/`) |
|------|------------------------|
| Main instructions | `src/main-instructions.md` |
| Agent definitions | `src/agents/{name}.md` |
| Command workflows | `src/commands/co-{name}.md` |
| Shared instructions | `src/instructions/{name}.md` |
| Skills | `src/skills/{name}/SKILL.md` |
| Memory & docs skeleton | `src/shared/{memory,docs}/` |

### How the build works

`src/` is parsed once into a model (`adapters/model.py`), then one **adapter per target** emits its native layout:

| Adapter | Output | Notes |
|---------|--------|-------|
| `adapters/copilot.py` | `dist/copilot/.github/` | Bodies verbatim; files renamed |
| `adapters/claude.py` | `dist/claude/` (a plugin) | Maps tool names, rewrites `$INPUT`→`$ARGUMENTS` and paths to `${CLAUDE_PLUGIN_ROOT}`, emits `plugin.json` + bootstrap `templates/` |

The repo root is itself a Claude **marketplace** (`.claude-plugin/marketplace.json` → `./dist/claude`).

**Adding an editor** (e.g. opencode): write `adapters/<tool>.py` exposing `TARGET` and `build(model)`, register it in `adapters/__init__.py`, and run the build. No other code changes.
