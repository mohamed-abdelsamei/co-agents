# Project Guidelines

## Agent Team & Prompts

See `README.md` for the full agent team, prompt reference, and SDLC workflow.

## Routing

- **Existing project, first time?** → `/co-init`
- **New feature?** → `/co-specify` → `/co-plan` → `/co-implement`
- **Refine existing feature?** → `/co-refine` (rewrite requirements, prune tasks, sync artifacts)
- **Bug to fix?** → `/co-bug` (tracked task + fix) or `/co-implement` (quick fix)
- **Quick experiment?** → `/co-experiment`
- **Understand a feature?** → `/co-assess`
- **Strategic decision?** → `/co-advise`
- **Need docs?** → `/co-document`
- **Implementation done?** → `/co-review`

## Docs Folder

`docs/` is the **primary source of truth** for architecture, research, and specs. Agents scan it before every task. When `docs/` and `.co-agents/` disagree, `docs/` wins.

## Project Memory

`.co-agents/` tracks operational artifacts — decisions, tasks, requirements, reviews, experiments. Templates and conventions are defined in `.github/instructions/memory.instructions.md`.

## Language & Stack Focus

<!-- Customize for your project after installation. Examples:
- **Languages**: TypeScript, Python
- **Frameworks**: Next.js, FastAPI
- **Infrastructure**: AWS CDK, Docker
-->
- **Languages**: (edit after install)
- **Frameworks**: (edit after install)
- **Infrastructure**: (edit after install)

Follow idiomatic patterns for each language. Prefer strong typing and null safety.

## Code Quality

Standards are defined in `.github/instructions/code-quality.instructions.md`. Customize thresholds and add language-specific rules below.
