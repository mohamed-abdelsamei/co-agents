---
description: "Refine an existing feature — rewrite requirements, prune obsolete tasks, sync all artifacts, and produce a clean implementation plan."
agent: architect
argument-hint: "Feature to refine (e.g., 'authentication' or point to a requirements file)"
---

The user wants to refine: **$INPUT**

## This Is a Refinement Session

You are rewriting and cleaning existing artifacts — not creating new ones or doing exploratory assessment. The goal is a clean, consistent set of requirements and tasks with no stale content.

## Precondition

Requirements MUST exist in `.co-agents/requirements/` for this feature. If they don't, stop and suggest `/co-specify`.

## Workflow

### 1. Load All Artifacts

Read everything related to this feature:
- `.co-agents/requirements/{feature}.md` — current requirements
- `.co-agents/tasks/{feature}-tasks.md` — current tasks (if exists)
- `.co-agents/decisions.md` — decisions referencing this feature
- `.co-agents/improvements.md` — logged issues for this feature
- `.co-agents/reviews/` — any review findings or analysis

### 2. Present Current State

Show the user a concise audit:

**Requirements** — List each REQ-ID with status and a one-line summary
**Tasks** — List each task ID with status (`[ ]`, `[x]`, `[~]`, `[-]`) and which REQ-ID it references
**Issues Found**:
- Requirements with no corresponding tasks
- Tasks referencing deleted or changed requirements
- Completed tasks whose requirements have shifted (implementation may be stale)
- Redundant or overlapping requirements
- Tasks that are no longer needed

### 3. Discuss Changes

Ask the user what to change. Structure the conversation:
- Which requirements should be **kept as-is**, **rewritten**, or **dropped**?
- Which tasks are **still valid**, **need updating**, or **should be removed**?
- Any **new requirements** to add?
- Any **scope changes** (things moving in or out)?

Maximum **3 discussion rounds**. After round 3, proceed with best understanding.

### 4. Rewrite Requirements

Rewrite `.co-agents/requirements/{feature}.md`:
- **Keep** requirements that are unchanged — preserve their REQ-IDs
- **Rewrite** requirements that changed — keep the same REQ-ID, update the text, add `(revised YYYY-MM-DD)` marker
- **Drop** requirements that are no longer needed — mark as `~~REQ-ID~~: (obsolete — {reason})` rather than deleting, so the ID is visibly retired and won't be reused
- **Add** new requirements with the next available REQ-ID in the sequence
- Update the `Last updated` date and set status to `approved`

### 5. Sync Tasks

Rewrite `.co-agents/tasks/{feature}-tasks.md`:
- **Completed tasks (`[x]`) for kept/unchanged requirements** — preserve as-is
- **Completed tasks for rewritten requirements** — mark `[!]` (needs re-verification) with note: `Requirement changed — verify implementation still matches`
- **Completed tasks for dropped requirements** — mark `[obsolete]` with reason
- **Not-started tasks (`[ ]`) for dropped requirements** — remove entirely
- **Not-started tasks for rewritten requirements** — update acceptance criteria to match new requirement text
- **Add new tasks** for any new requirements (follow standard task rules: REQ-ID reference, acceptance criteria, complexity)
- Remove any tasks that are redundant or duplicated

### 6. Cascade Updates

- **decisions.md** — If any decisions are invalidated by the changes, mark them `superseded` and add a new entry explaining the change
- **improvements.md** — Remove entries that are addressed by the refinement; add new ones if the rewrite surfaces issues
- **reviews/** — Note that prior reviews may be stale; suggest `/co-review` after re-implementation

### 7. Summary

Present a change summary:

| Category | Count |
|----------|-------|
| Requirements kept | N |
| Requirements rewritten | N |
| Requirements dropped | N |
| Requirements added | N |
| Tasks preserved | N |
| Tasks need re-verification | N |
| Tasks marked obsolete | N |
| Tasks removed | N |
| Tasks added | N |

Then suggest next steps:
- Tasks marked `[!]` → `/co-implement` to re-verify
- New tasks → `/co-implement` to build
- If substantial changes → `/co-analyze` first to verify consistency

## Scope Guard

Refinement and planning only. Do not write implementation code. When the clean plan is ready, hand off to `/co-implement`.

## Done When

Requirements file is rewritten, tasks file is synced, cascade updates are applied, and a clean summary is delivered.
