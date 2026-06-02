---
description: "Single source of truth for all project memory file formats. Applied automatically when editing .co-agents/** files."
---

# Project Memory Standards

Two committed locations, **one home per artifact** — never keep duplicate copies
of the same thing across them:

- **`docs/`** — Durable source-of-truth documents: the architecture overview
  (`docs/architecture.md`), design specs, API references, and guides.
- **`.co-agents/`** — Operational/working memory: constitution, decisions,
  improvements, requirements, tasks, reviews, research findings, experiments.

On a conflict, the artifact's designated home (per the ownership table below) wins.

## Memory Directory Structure

```
docs/
├── architecture.md          # Architecture overview — single home (not duplicated in .co-agents/)
└── {specs, API refs, guides}

.co-agents/
├── constitution.md          # Non-negotiable project principles and quality gates
├── decisions.md             # Architectural decisions — append-only ADR log
├── improvements.md          # Tech debt and improvement backlog
├── requirements/            # Feature requirements — one file per feature
│   └── {feature}.md
├── tasks/                   # Implementation plans — one file per feature
│   └── {feature}-tasks.md
├── reviews/                 # Review reports, consistency analyses, and critiques
│   ├── {feature}-review.md
│   ├── {feature}-analysis.md
│   └── {topic}-critique.md
├── research/                # Research findings — one file per topic, plus README.md (knowledge index)
│   ├── README.md            # Living knowledge map: what we know / what's open
│   └── {topic}.md
└── experiments/             # Experiment findings and demo scripts
    ├── {experiment}.md
    └── {demo}-demo.md
```

## Agent Permissions

| Agent | Reads | Writes |
|-------|-------|--------|
| **architect** | `docs/`, constitution, decisions, improvements, research/, requirements/ | `docs/` (incl. `architecture.md`), requirements/, tasks/, decisions, reviews/ |
| **engineer** | `docs/`, constitution, decisions, requirements/, tasks/ | tasks/ (status), decisions, improvements, experiments/ |
| **devops** | `docs/` (incl. `architecture.md`), constitution, decisions, requirements/, tasks/ | tasks/ (status), decisions, improvements |
| **researcher** | `docs/`, constitution, decisions, requirements/, improvements, research/ | research/ (full findings + index), `docs/` (reference docs) |
| **critic** | everything (read-only): `docs/`, constitution, decisions, improvements, requirements/, tasks/, reviews/, research/ | reviews/ (critiques), improvements (append risks), decisions (flag annotations only) |

**Special case**: `/co-init` writes `docs/architecture.md`, plus `decisions.md` (inferred), `improvements.md`, and `constitution.md`.

## Document Consolidation

**One file per feature.** Never create a second file for the same feature or topic.

### Update-First Rule

Before creating any file in `.co-agents/` or `docs/`, scan the target directory for an existing file covering the same feature or topic. If found, **update it in-place** rather than creating a new file.

| File type | If exists | Action |
|-----------|-----------|--------|
| `requirements/{feature}.md` | Update requirements in-place. Add new REQ-IDs, revise existing ones. Preserve active requirement IDs referenced by tasks. Mark dropped requirements as `obsolete` (don't delete — retire the ID). |
| `tasks/{feature}-tasks.md` | Update/add tasks. Preserve completed task statuses (`[x]`). Mark tasks for dropped requirements as `[obsolete]`. Mark tasks for changed requirements as `[!]` (needs re-verification). |
| `reviews/{feature}-review.md` | **Overwrite** with latest review. The most recent review is the source of truth. |
| `reviews/{feature}-analysis.md` | **Overwrite** with latest analysis. |
| `reviews/{topic}-critique.md` | **Overwrite** with the latest critique of that topic. |
| `decisions.md` | **Append** new entries. Check existing entries first — do not duplicate a decision already recorded. |
| `improvements.md` | **Append** new entries. Check existing entries first — do not duplicate an improvement already tracked. |
| `docs/{topic}.md` | **Update** existing document. Revise outdated sections, add new content. Do not create a second file. |
| `research/{topic}.md` | **Update** the existing research document in-place. One file per topic. Add new findings, revise stale ones, refresh source dates. |
| `research/README.md` | **Update** the knowledge index whenever a research file is added or changed. |
| `experiments/{name}.md` | Each experiment is unique — create new files. |

### Last Updated

Every document must include `Last updated: YYYY-MM-DD` in its header. Update this date on every modification.

## Conventions

- **Dates**: ISO 8601 (`YYYY-MM-DD`)
- **Paths**: Full path from outside memory (`.co-agents/requirements/{feature}.md`); relative between memory files
- **Naming**: kebab-case for all filenames
- **Cross-refs**: Link related files with relative markdown links (tasks → requirements by REQ-ID, reviews → requirements + tasks)
- **Lifecycle**: Files are never deleted. Update `status` to reflect current state.

### Status Values

| File Type | Statuses |
|-----------|----------|
| Constitution | `draft` → `active` |
| Decisions | `accepted` → `superseded` · `deprecated` |
| Requirements | `draft` → `approved` → `implemented` · `obsolete` |
| Research | `draft` → `complete` |
| Experiments | `success` · `partial` · `failed` |

Individual requirements within a file can be marked `obsolete` with a reason: `~~REQ-ID~~: (obsolete — {reason})`. This retires the ID so it won't be reused.

### Task Status

```
- [ ]  not started
- [~]  in progress
- [x]  done
- [!]  needs re-verification (requirement changed)
- [-]  blocked (add reason)
- [obsolete]  no longer needed (add reason)
```

### Cascade Rules

When a requirement is **rewritten**, all tasks referencing it must be re-evaluated:
- Not-started tasks → update acceptance criteria to match new requirement
- Completed tasks → mark `[!]` (needs re-verification)

When a requirement is **dropped**, all tasks referencing it must be handled:
- Not-started tasks → remove entirely
- Completed tasks → mark `[obsolete]` with reason

When tasks are marked `[obsolete]` or `[!]`, prior reviews referencing them are stale — note this and suggest `/co-review`.

---

## Templates

