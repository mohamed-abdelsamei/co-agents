# Co-Agents

A structured SDLC workflow for GitHub Copilot — 4 specialized agents, 15 prompts, and a persistent project memory system that turns Copilot into a full development team.

## Quick Start

Install into your project directory:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mohamed-abdelsamei/co-agents/main/remote-install.sh) .
```

For private repos, add `--ssh`. See [install options](#install-options) for more.

Then:

1. Edit `.github/copilot-instructions.md` to define your stack (languages, frameworks, infrastructure)
2. Run `/co-init` to scan the codebase and populate project memory
3. Run `/co-constitution` to define project principles

## Agents

| Agent | Role |
|-------|------|
| `@architect` | Requirements, architecture, infra design, task planning, strategic advice |
| `@engineer` | Implementation, debugging, infrastructure-as-code, TDD, experiments, demos |
| `@reviewer` | Code review, consistency analysis |
| `@researcher` | Research, comparisons, documentation |

## Workflow

```
/co-init → /co-constitution → /co-specify → /co-clarify → /co-plan → /co-analyze → /co-implement → /co-review
```

Research (`/co-research`), documentation (`/co-document`), advisory (`/co-advise`), and assessment (`/co-assess`) can be used at any phase.

**Experiment fast-track:**

```
/co-experiment → (success?) → /co-specify → full SDLC
```

## Prompts

| What You Need | Prompt | Agent |
|---------------|--------|-------|
| Onboard existing project | `/co-init` | `@architect` |
| Define principles | `/co-constitution` | `@architect` |
| Gather requirements | `/co-specify` | `@architect` |
| Resolve ambiguity | `/co-clarify` | `@architect` |
| Plan & break into tasks | `/co-plan` | `@architect` |
| Strategic advice | `/co-advise` | `@architect` |
| Assess existing feature | `/co-assess` | `@architect` |
| Pre-build consistency check | `/co-analyze` | `@reviewer` |
| Review implementation | `/co-review` | `@reviewer` |
| Implement features / debug | `/co-implement` | `@engineer` |
| Report & fix a bug | `/co-bug` | `@engineer` |
| Quick experiment | `/co-experiment` | `@engineer` |
| Prepare a demo | `/co-demo` | `@engineer` |
| Research a topic | `/co-research` | `@researcher` |
| Write documentation | `/co-document` | `@researcher` |

## What Gets Installed

```
your-project/
├── .github/
│   ├── agents/           4 agent definitions
│   ├── prompts/          15 prompt workflows
│   ├── instructions/     Memory format standards + pre-check rules
│   ├── skills/           Workflow skills (co-memory)
│   └── copilot-instructions.md
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

## Project Memory

Every decision, requirement, and review is tracked in `.co-agents/` — committed to version control so context is never lost. `docs/` is the primary source of truth for architecture and specs; `.co-agents/` tracks operational artifacts.

| Directory | Contents |
|-----------|----------|
| `constitution.md` | Non-negotiable principles and quality gates |
| `decisions.md` | Append-only architecture decision records |
| `requirements/` | One file per feature — testable requirements |
| `tasks/` | Implementation plans broken into tracked tasks |
| `reviews/` | Structured review reports with verdicts |
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
