---
name: grill-with-org
description: "Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates living documentation inline as decisions crystallise — emitting Emacs Org-mode files (CONTEXT.org, decisions.org) instead of markdown. Treats docs as a queryable data model: headlines carry IDs, property drawers, tags and TODO/agenda state, so the glossary becomes a navigable graph and decisions become a column-view table. Use when the user wants to stress-test a plan against their project's language and documented decisions and prefers Org-mode output, or mentions org-mode, org files, org-agenda, or column view."
---

<what-to-do>

Interview the user relentlessly about every aspect of this plan until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

</what-to-do>

<supporting-info>

This skill behaves exactly like a plan-grilling session, but its documentation artefacts are **Emacs Org-mode** files, not markdown. Org is a *data format*: headlines, property drawers, IDs, tags, and TODO keywords make the docs queryable (agenda, column view, sparse trees, `id:` links) rather than merely readable. Use that — don't just write markdown with `*` headings.

The user is comfortable with org.

For the exact file formats and the org features they use, follow the references — don't rely on memory:

- [references/ORG-PRIMER.md](references/ORG-PRIMER.md) — the org features this skill relies on (property drawers, IDs, `id:` links, TODO keywords, tags, column view, agenda).
- [references/CONTEXT-FORMAT.md](references/CONTEXT-FORMAT.md) — the glossary file (`CONTEXT.org`).
- [references/DECISIONS-FORMAT.md](references/DECISIONS-FORMAT.md) — the decisions file (`decisions.org`), the org-native replacement for a `docs/adr/` directory.

## Domain awareness

During codebase exploration, also look for existing documentation. Detect what's already there before creating anything:

- An existing `CONTEXT.org` (or `CONTEXT.md` — see migration note below) → the glossary.
- An existing `decisions.org`, or a legacy `docs/adr/` directory of markdown ADRs.
- A `CONTEXT-MAP.org` at the root → the repo has multiple bounded contexts; read it to find where each lives. Otherwise assume a single context with a root `CONTEXT.org`.

```
/                          single context (most repos)
├── CONTEXT.org            glossary
├── decisions.org          all architectural decisions, as headlines
└── src/
```

```
/                          multiple contexts
├── CONTEXT-MAP.org        lists contexts + how they relate
├── decisions.org          system-wide decisions
└── src/
    ├── ordering/
    │   ├── CONTEXT.org
    │   └── decisions.org   context-specific decisions
    └── billing/
        └── CONTEXT.org
```

Create files lazily — only when you have something to write. No `CONTEXT.org`? Create it when the first term is resolved. No `decisions.org`? Create it when the first decision qualifies.

**Migration:** if you find a markdown `CONTEXT.md` or a `docs/adr/*.md` directory, point it out and offer to migrate it into org. Don't migrate silently. When you do, preserve all content and enrich it with IDs/properties/tags per the reference formats.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.org`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.org inline

When a term is resolved, update `CONTEXT.org` right there. Don't batch these up — capture them as they happen. Use the format in [references/CONTEXT-FORMAT.md](references/CONTEXT-FORMAT.md): each term is a headline with an `:ID:`, an `:AVOID:` property for aliases, context tags, and `[[id:...]]` links to related terms.

When a term is mentioned but *not yet resolved* — a genuine ambiguity — capture it as a `TODO` headline so it surfaces in the user's agenda as something to pin down. Resolve it (flip to a defined term, drop the TODO) once settled.

`CONTEXT.org` should be totally devoid of implementation details. Do not treat it as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Offer decisions sparingly

Only offer to record a decision in `decisions.org` when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip it. Use the format in [references/DECISIONS-FORMAT.md](references/DECISIONS-FORMAT.md): a new headline with `TODO` state (unresolved) or `ACCEPTED` (settled), an `:ID:`, a `:DATE:` property, and context/topic tags.

### Emit open questions as TODO

When the grill surfaces an unresolved question, blocker, or follow-up investigation, emit it immediately as a `* TODO` headline in `decisions.org` with:
- `:ID:` prefixed `q-` (not `dec-`) — e.g. `q-prod-access`
- `:DATE:` of today
- Topic tags including `:open-question:`
- `[[id:]]` link to the related decision

These are work items, not decisions. When resolved, either promote to a proper decision (with `dec-` ID and `ACCEPTED` state) if it meets the three-bar test, or simply delete the headline.

### Agenda note

These files are designed for the project-local agenda. `TODO` headlines (left of `|`) appear as actionable items; `ACCEPTED`/`DEPRECATED`/`SUPERSEDED` are resolved and hidden. All open items use a single `TODO` state — find them across the project with `grep -r "^\* TODO" .`.

</supporting-info>
