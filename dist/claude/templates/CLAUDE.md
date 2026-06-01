# Project Guidelines

## Agent Team & Prompts

See `README.md` for the full agent team, prompt reference, and SDLC workflow.

## Routing

- **New project from scratch?** → `/co-setup`
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

## Memory Locations

Project memory lives in two committed locations with **one home per artifact** — no duplicate copies across them:

- **`docs/`** — durable source-of-truth documents: the architecture overview (`docs/architecture.md`), design specs, API references, and guides.
- **`.co-agents/`** — operational/working memory: constitution, decisions, improvements, requirements, tasks, reviews, research findings, experiments.

On a conflict, the artifact's designated home wins. Templates and conventions are defined in `${CLAUDE_PLUGIN_ROOT}/instructions/memory.md`.

## Language & Stack Focus

- **Languages**: TypeScript, Dart, Rust, Python
- **Frameworks**: (edit after install)
- **Infrastructure**: (edit after install)

Follow idiomatic patterns for each language. Prefer strong typing and null safety.

## Code Quality

Standards are defined in `${CLAUDE_PLUGIN_ROOT}/instructions/code-quality.md`. Customize thresholds and add language-specific rules below.
