# Project Guidelines

## Agent Team & Prompts

See `README.md` for the full agent team, prompt reference, and SDLC workflow.

## Routing

- **Existing project, first time?** → `/co-init`
- **New feature?** → `/co-spec` → `/co-plan` → `/co-build`
- **Refine existing feature?** → `/co-spec` (detects existing requirements and switches to refine mode)
- **Bug to fix?** → `/co-fix` (tracked task + fix) or `/co-build` (quick fix)
- **Quick experiment?** → `/co-build` (detects experiment/spike intent)
- **Understand a feature?** → `/co-advise` (detects assessment intent)
- **Strategic decision?** → `/co-advise`
- **Need docs?** → `/co-docs`
- **Research a topic?** → `/co-research`
- **Implementation done?** → `/co-review`
- **Infrastructure / CI/CD?** → `/co-deploy`

## Docs Folder

`docs/` is the **primary source of truth** for architecture, research, and specs. Agents scan it before every task. When `docs/` and `.co-agents/` disagree, `docs/` wins.

## Project Memory

`.co-agents/` tracks operational artifacts — decisions, tasks, requirements, reviews, experiments. Templates and conventions are defined in `.github/instructions/memory.instructions.md`.

## Language & Stack Focus

- **Languages**: TypeScript, Dart, Rust, Python
- **Frameworks**: (edit after install)
- **Infrastructure**: (edit after install)

Follow idiomatic patterns for each language. Prefer strong typing and null safety.

## Code Quality

Standards are defined in `.github/instructions/code-quality.instructions.md`. Customize thresholds and add language-specific rules below.
