---
name: to-issues-with-org
description: Break a plan, spec, or PRD into independently-grabbable work items in backlog.org using tracer-bullet vertical slices with TODO lifecycle, id-link dependencies, and agenda integration. Use when user wants to convert a plan into tasks and prefers org-mode output, mentions backlog.org, or the project already uses org files for planning.
---

# To Issues (Org)

Break a plan into independently-grabbable work items using vertical slices (tracer bullets), written as TODO headlines in `backlog.org`.

The output is a queryable data model: TODO states surface in the agenda, `:BLOCKED:` properties encode the dependency graph as followable `id:` links, and column view gives a sortable task dashboard.

For the exact file formats and the org features they use, follow the references — don't rely on memory:

- [references/ORG-PRIMER.md](references/ORG-PRIMER.md) — the org features this skill relies on.
- [references/BACKLOG-FORMAT.md](references/BACKLOG-FORMAT.md) — the backlog file structure and rules.
- [references/DECISIONS-FORMAT.md](references/DECISIONS-FORMAT.md) — for linking to decisions.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a PRD reference (an `:ID:` slug, a headline title, or a file path) as an argument, read it from `prd.org`.

Also detect existing org files:
- `CONTEXT-MAP.org` → multi-context repo.
- `CONTEXT.org` → the glossary. Use its terms (with `[[id:]]` links) in task descriptions.
- `decisions.org` → existing architectural decisions.
- `prd.org` → parent PRD to link back to via `:PRD:` property.
- `backlog.org` → append new items rather than creating a new file.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state. Task descriptions should use the project's domain glossary vocabulary and respect existing decisions.

### 3. Draft vertical slices

Break the plan into **tracer bullet** work items. Each item is a thin vertical slice cutting through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices are tagged `:hitl:` or `:afk:`:
- `:afk:` — can be implemented and merged without human interaction. Prefer this.
- `:hitl:` — requires a human decision, design review, or access grant.

Rules:
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests).
- A completed slice is demoable or verifiable on its own.
- Prefer many thin slices over few thick ones.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: `:hitl:` / `:afk:`
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as `:hitl:` and `:afk:`?

Iterate until the user approves the breakdown.

### 5. Write the work items

Write all approved items to `backlog.org` using the format in [references/BACKLOG-FORMAT.md](references/BACKLOG-FORMAT.md).

Key rules:
- If `backlog.org` doesn't exist, create it with the full file header (TODO keywords, column view, etc.).
- If it already exists, append new items as new top-level headlines.
- Write items in dependency order (blockers first) so `:BLOCKED:` links resolve.
- All items start as `TODO`.
- Link glossary terms with `[[id:term-slug][Term]]` for any term in `CONTEXT.org`. Don't create new glossary entries.
- Set `:PRD:` to `[[id:prd-slug]]` if a parent PRD exists.
- Write all items at once after approval (not incrementally) so the dependency graph is coherent.

### 6. Teach org features

When you use an org feature for the first time in the session, add a one-line `# ` comment in the file and mention in chat what it unlocks:
- Column view: "press `C-c C-x C-c` on the top headline for a dashboard of all tasks"
- Blocked-by links: "`C-c C-o` on a `:BLOCKED:` link jumps to the blocking task"
- Agenda filtering: "in agenda view, `/` then type `afk` to see only agent-doable tasks"
- TODO cycling: "`C-c C-t` to move a task through TODO → IN-PROGRESS → DONE"
