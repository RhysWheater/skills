---
name: to-prd-with-org
description: "Turn the current conversation context into a PRD and write it to prd.org as a structured Org-mode document with TODO lifecycle, id links, and agenda integration. Use when user wants to create a PRD and prefers org-mode output, mentions prd.org, or the project already uses org files for planning."
---

This skill takes the current conversation context and codebase understanding and produces a PRD as a structured Org-mode file. Do NOT interview the user — just synthesize what you already know (use `grill-with-org` first if the plan needs stress-testing).

The output is `prd.org` — a queryable data model, not just prose. Headlines carry IDs, TODO states surface in the agenda, and `id:` links connect the PRD to the glossary and decisions.

For the exact file formats and the org features they use, follow the references — don't rely on memory:

- [references/ORG-PRIMER.md](references/ORG-PRIMER.md) — the org features this skill relies on.
- [references/PRD-FORMAT.md](references/PRD-FORMAT.md) — the PRD file structure and rules.
- [references/DECISIONS-FORMAT.md](references/DECISIONS-FORMAT.md) — for linking to or creating decisions.

## Process

### 1. Explore the repo

Understand the current codebase state, if you haven't already. Also detect existing org files:

- `CONTEXT-MAP.org` → multi-context repo; read it to find where each context lives.
- `CONTEXT.org` → the glossary. Use its terms (with `[[id:]]` links) throughout the PRD.
- `decisions.org` → existing architectural decisions. Link to relevant ones.
- `prd.org` → append a new headline rather than creating a new file.

If none exist, create `prd.org` lazily when you write the PRD. Use the project's domain glossary vocabulary throughout.

### 2. Sketch modules and confirm

Sketch out the major modules you will need to build or modify. Actively look for deep modules — ones that encapsulate a lot of functionality behind a simple, testable interface.

Present the module list to the user and ask:
- Do these modules match your expectations?
- Which modules should have tests?

Wait for confirmation before proceeding.

### 3. Write the PRD

Write the PRD to `prd.org` using the format in [references/PRD-FORMAT.md](references/PRD-FORMAT.md).

Key rules:
- Start the PRD in `TODO` state — the user flips to `APPROVED` when satisfied.
- If `prd.org` doesn't exist, create it with the full file header (TODO keywords, column view, etc.).
- If it already exists, append the new PRD as a new top-level headline.
- Link glossary terms with `[[id:term-slug][Term]]` for any term that exists in `CONTEXT.org`. Don't create new glossary entries.
- Link to existing decisions in `decisions.org`. Only create new decision entries when a genuine architectural trade-off surfaces during the module step (must meet the three-bar test: hard to reverse, surprising without context, real alternatives).
- User stories should be extensive — cover all aspects of the feature.
- No file paths or code snippets in Problem/Solution/User Stories.

