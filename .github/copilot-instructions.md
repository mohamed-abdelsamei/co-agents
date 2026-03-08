# Project Guidelines

## Agent Team

| Agent | Role |
|-------|------|
| `@architect` | Requirements, architecture, infra design, task planning, strategic advice |
| `@engineer` | Implementation, debugging, infrastructure-as-code, TDD, experiments, demos |
| `@reviewer` | Code review, consistency analysis |
| `@researcher` | Research, comparisons, documentation |

## Prompts

| Prompt | Agent | Purpose |
|--------|-------|---------|
| `/co-init` | `@architect` | Scan existing codebase, populate project memory |
| `/co-constitution` | `@architect` | Define project principles and quality gates |
| `/co-specify` | `@architect` | Gather requirements with uncertainty markers |
| `/co-clarify` | `@architect` | Disambiguate requirements before planning |
| `/co-plan` | `@architect` | Plan implementation with phased tasks |
| `/co-advise` | `@architect` | RFC review, tradeoff analysis, design critique |
| `/co-analyze` | `@reviewer` | Pre-build consistency check |
| `/co-review` | `@reviewer` | Post-implementation review |
| `/co-implement` | `@engineer` | Build features, fix bugs, debug issues |
| `/co-experiment` | `@engineer` | Quick spike — hypothesis → code → findings |
| `/co-demo` | `@engineer` | Demo preparation — goals → code → script |
| `/co-research` | `@researcher` | Investigate a topic, compare technologies |
| `/co-document` | `@researcher` | Write reference docs, READMEs, specs |

## SDLC Flow

```
/co-init → /co-constitution → /co-specify → /co-clarify → /co-plan → /co-analyze → /co-implement → /co-review
```

Research (`/co-research`), documentation (`/co-document`), and advisory (`/co-advise`) can be used at any phase.

### Experiment Fast-Track

```
/co-experiment → (success?) → /co-specify → full SDLC
```

## Routing

- **Existing project, first time?** → `/co-init`
- **New feature?** → `/co-specify` → `/co-plan` → `/co-implement`
- **Bug to fix?** → `/co-implement` (auto-detects debug mode)
- **Quick experiment?** → `/co-experiment`
- **Strategic decision?** → `/co-advise`
- **Need docs?** → `/co-document`
- **Implementation done?** → `/co-review`

## Docs Folder

`docs/` is the **primary source of truth** for architecture, research, and specs. Agents scan it before every task. When `docs/` and `.co-agents/` disagree, `docs/` wins.

## Project Memory

`.co-agents/` tracks operational artifacts — decisions, tasks, requirements, reviews, experiments. Templates and conventions are defined in `.github/instructions/memory.instructions.md`.

## Language & Stack Focus

<!-- Customize for your project after installation -->
- **Languages**: (edit after install)
- **Frameworks**: (edit after install)
- **Infrastructure**: (edit after install)

Follow idiomatic patterns for each language. Prefer strong typing and null safety.

## Code Quality

- Run security scans on new or modified code
- Write tests for critical paths; use TDD for complex logic
- Infrastructure stacks should have assertion tests
- Keep functions focused and files well-organized
