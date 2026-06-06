# Project memory (`.coagents/`)

This folder is the **co-agents team's memory** for this project. It's committed to version
control so the context and rationale behind the team's work travel with the repo and survive
between sessions.

## What lives here

| Folder | Holds |
|--------|-------|
| `charter.md` | This project's principles, goals, and tech stack. Read first. |
| `discussions/` | Summaries of brainstorm sessions — who argued what, and the decision. |
| `decisions/` | The decision log (ADR style) — one file per decision, with rationale. |
| `requirements/` | Specs — what we're building, with testable requirements. |
| `tasks/` | Task breakdowns with owners and status. |
| `research/` | Sourced findings and options comparisons. |
| `reviews/` | Code reviews and decision critiques. |

## How to use it

- **You** can browse any of this to see why things are the way they are.
- **The team** reads it for context and writes to it as work happens — the architect records
  decisions and tasks, the researcher records findings, the reviewer records critiques, the
  scribe records discussions.

Durable, polished documentation (architecture overview, guides, API references) lives in
`docs/`, not here — one home per artifact, no duplicates.

## Commands

- `/team-init` — start the team on a new project · `/team-onboard` — onboard to an existing one.
- `/team-brainstorm <topic>` — convene the team to debate and decide.
- `/team-plan <feature>` — turn a requirement into a design and tasks.
- `/team-build <task>` — implement → test → review.
- `/team-review <target>` — review code or stress-test a decision.
- `/team-ask <question>` — ask about any decision, term, or topic; get a plain explanation.
- `/team-grill <idea>` — be interrogated on your own reasoning, one sharp question at a time.
- `/team-delegate <request>` — let the Maestro route it.
- Or talk to any specialist directly: `@architect`, `@engineer`, `@tester`, `@reviewer`,
  `@researcher`, `@scribe`.
