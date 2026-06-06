## Getting started in a project

- **New project, little/no code** → `/team-init` (interview → charter → scaffold `.coagents/`).
- **Existing project with a codebase or history** → `/team-onboard` (scan and *understand* it,
  then build `.coagents/`). Run this before doing real work in an unfamiliar repo.
- At the start of any session in a project that already has `.coagents/`, skim `charter.md` and
  recent `decisions/` first.

### Respect existing project context (standing rule)

Never modify a project's existing AI-context files — `CLAUDE.md`, `AGENTS.md`,
`.github/copilot-instructions.md`, `context.md`, `.cursorrules`, and the like. **Read and obey
them; treat them as authoritative.** The team writes its own memory to `.coagents/` to
*complement* those files, never to duplicate or override them. If one looks wrong, flag it for the
user — don't unilaterally edit it.