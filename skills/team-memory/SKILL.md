---
name: team-memory
description: "Conventions for the co-agents per-project memory folder (.coagents/). Use when reading or writing project memory — discussions, decisions, requirements, tasks, research, reviews — so all agents record consistently and nothing is lost between sessions."
---

# Team memory (`.coagents/`)

Every project the team works on keeps a committed `.coagents/` folder. It is the team's shared,
version-controlled memory — the trace of what was discussed, decided, required, built, and
reviewed. Read it at the start of a session; write to it whenever a session produces something
worth keeping.

## Layout

```
.coagents/
  README.md         how this memory works (human-facing)
  charter.md        project principles + stack — READ FIRST every session
  discussions/      brainstorm summaries:  {YYYY-MM-DD}-{slug}.md
  decisions/        ADR-style log:          {NNNN}-{slug}.md  (one decision per file)
  requirements/     specs:                  {slug}.md
  tasks/            task breakdowns:        {slug}.md  (checklist with owners + status)
  research/         sourced findings:       {slug}.md  (with sources, dates, confidence)
  reviews/          review & critique reports: {slug}.md
```

## Rules

- **One home per artifact.** Durable, polished docs (architecture overview, guides, API refs)
  live in `docs/`. Operational/working memory lives in `.coagents/`. Never keep the same content
  in both — link instead.
- **Write permissions by agent** (each stays in its lane):
  - `@architect` → `requirements/`, `decisions/`, `tasks/`, design docs in `docs/`
  - `@engineer` → code, `tasks/` (status), `decisions/` (implementation decisions)
  - `@tester` → `reviews/` (test plans/verification), test code, `tasks/` (status)
  - `@reviewer` → `reviews/`; may *flag* a `decisions/` entry (annotate, never rewrite)
  - `@researcher` → `research/`, reference material in `docs/`
  - `@scribe` → `discussions/`, `decisions/` (recording on the team's behalf), `docs/`
- **Everyone reads everything.** Memory is shared context, not siloed.
- **These scopes are conventions, not a sandbox.** Write-permissions and tool grants are rules the
  agents follow — they are *not* hard-enforced. An agent can technically touch anything its granted
  tools allow. Keep `.coagents/` (and your code) under version control so any unintended change
  shows up in the diff and can be reverted. That diff is your real guardrail.
- **Date and attribute.** Discussions and decisions carry a date; positions in a discussion are
  attributed to the agent who held them.
- **Keep it current.** When a decision is superseded, update the entry and note what replaced it.
  A stale decision is worse than none.
- **Write for the user to read alone, later.** Every artifact must be understandable by the user
  without the team present: plain language, lead with the point, **define non-obvious terms** the
  first time they appear, and always record the **why**, not just the what. A decision with no
  rationale is unreviewable. This is what makes `/team-ask` able to answer "what does this mean /
  why did we decide this" from the record.

## Templates

### Decision (ADR) — `decisions/{NNNN}-{slug}.md`
```markdown
# {NNNN}. {Title}

- **Date:** {YYYY-MM-DD}
- **Status:** Proposed | Accepted | Superseded by {NNNN}

## Context
What's the situation and the forces at play?

## Decision
What we decided, and why this over the alternatives.

## Alternatives considered
- Option A — rejected because…
- Do nothing — …

## Consequences
What this makes easier, harder, or commits us to. Known risks.
```

### Discussion summary — `discussions/{YYYY-MM-DD}-{slug}.md`
```markdown
# {Topic} — {YYYY-MM-DD}

**Question:** one or two sentences.

**Positions**
- Sol (@architect): …
- Max (@engineer): …
- Cass (@reviewer): …
- Ada (@researcher): …

**Tensions:** the real disagreements.

**Decision:** what was agreed (link the decisions/ entry).

**Open questions:** what's unresolved / needs a spike.
```

### Task list — `tasks/{slug}.md`
```markdown
# Tasks: {feature}

Requirement: ../requirements/{slug}.md

- [ ] 1. {task} — owner: @engineer — done when: {condition} — deps: none
- [ ] 2. {task} — owner: @tester — done when: {condition} — deps: 1
```
Status markers: `[ ]` todo, `[x]` done, `[~]` in progress, `[!]` needs re-verification.
