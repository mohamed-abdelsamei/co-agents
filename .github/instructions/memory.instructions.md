---
description: "Single source of truth for all project memory file formats. Applied automatically when editing .co-agents/** files."
applyTo: ".co-agents/**"
---

# Project Memory Standards

- **`docs/`** — Primary source of truth for architecture, research, and specs. Agents read it first. Wins on conflicts.
- **`.co-agents/`** — Operational tracking: decisions, tasks, requirements, reviews, experiments.

## Memory Directory Structure

```
.co-agents/
├── constitution.md          # Non-negotiable project principles and quality gates
├── decisions.md             # Architectural decisions — append-only ADR log
├── architecture.md          # Architecture summary (full docs live in docs/)
├── improvements.md          # Tech debt and improvement backlog
├── requirements/            # Feature requirements — one file per feature
│   └── {feature}.md
├── tasks/                   # Implementation plans — one file per feature
│   └── {feature}-tasks.md
├── reviews/                 # Review reports and consistency analyses
│   ├── {feature}-review.md
│   └── {feature}-analysis.md
├── research/                # Research index — full docs live in docs/
└── experiments/             # Experiment findings and demo scripts
    ├── {experiment}.md
    └── {demo}-demo.md
```

## Agent Permissions

| Agent | Reads | Writes |
|-------|-------|--------|
| **architect** | `docs/`, constitution, decisions, improvements, research/, requirements/ | `docs/`, requirements/, tasks/, decisions |
| **engineer** | `docs/`, constitution, decisions, requirements/, tasks/ | tasks/ (status), decisions, improvements, experiments/ |
| **reviewer** | `docs/`, constitution, decisions, requirements/, tasks/ | reviews/, tasks/ (fix tasks only) |
| **researcher** | `docs/`, constitution, decisions, research/ | `docs/` (primary), research/ (index) |

**Special case**: `/co-init` writes `architecture.md`, `decisions.md` (inferred), and `improvements.md`.

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
| `decisions.md` | **Append** new entries. Check existing entries first — do not duplicate a decision already recorded. |
| `improvements.md` | **Append** new entries. Check existing entries first — do not duplicate an improvement already tracked. |
| `docs/{topic}.md` | **Update** existing document. Revise outdated sections, add new content. Do not create a second file. |
| `research/{topic}.md` | **Update** existing index entry. One index entry per topic. |
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

