# prd.org format

All PRDs for a project live as top-level headlines in one file. Org's column view gives a dashboard of every PRD and its status; the agenda surfaces those still `TODO`. See [ORG-PRIMER.md](ORG-PRIMER.md) for any feature below.

## Why one file

Same reasoning as decisions.org — one file lets column view aggregate all PRDs into a sortable table. Each PRD is a top-level headline; its sections are sub-headlines. The file stays navigable because org's folding (`TAB`) collapses everything to a one-line-per-PRD outline.

## File header

```org
# Product requirements, one per top-level headline.
#+TITLE: PRDs
#+CATEGORY: prd
#+FILETAGS: :prd:
# Keywords: left of | = open (visible in agenda), right = resolved (hidden).
#+TODO: TODO(t) | APPROVED(a) CANCELLED(c)
#+COLUMNS: %40ITEM(PRD) %TODO(Status) %DATE %TAGS
#+STARTUP: overview
```

- `TODO` — open (being drafted or awaiting approval).
- `APPROVED` — approved, work can begin.
- `CANCELLED` — abandoned.

## A PRD

```org
* TODO Order pipeline  :ordering:
  :PROPERTIES:
  :ID:    prd-order-pipeline
  :DATE:  [2026-06-11]
  :END:
** Problem
   Customers cannot place orders because the pipeline has no write path.
** Solution
   Implement an event-sourced write model with projected read views.
** User Stories
   1. As a [[id:cust-customer][Customer]], I want to place an [[id:ord-order][Order]], so that I can purchase goods.
   2. As an operator, I want to see order status in real time, so that I can intervene on failures.
   3. ...
** Modules
   - ~OrderCommandHandler~ — receives commands, emits events
   - ~OrderProjection~ — projects events into read model
   - ~OrderAPI~ — HTTP surface for the command handler
** Decisions
   Links to relevant entries in decisions.org:
   - [[id:dec-event-sourced-write-model]]
   - [[id:dec-events-not-http]]
** Testing
   - OrderCommandHandler: unit tests (pure function, event-in/event-out)
   - OrderProjection: integration test against real Postgres
   - Prior art: see ~tests/billing/projection_test.exs~
** Out of Scope
   - Payment processing (separate context)
   - Admin UI (future PRD)
** Notes
   Any further context, links to external docs, or prototype snippets.
```

## Sections

All sub-headlines are optional — include only those with content:

- **Problem** — the user's problem, from their perspective.
- **Solution** — the proposed solution, from the user's perspective.
- **User Stories** — numbered list, `As a <actor>, I want <feature>, so that <benefit>`. Extensive — cover all aspects. Use `[[id:]]` links for glossary terms.
- **Modules** — the major modules to build or modify. Deep modules preferred (encapsulate complexity behind simple interfaces). These are confirmed with the user before the PRD is written.
- **Decisions** — `[[id:dec-*]]` links to decisions.org entries. Do NOT duplicate decision content here. If a decision doesn't exist yet but meets the three-bar test, create it in decisions.org first, then link.
- **Testing** — which modules get tests, what kind, and prior art pointers.
- **Out of Scope** — explicit boundaries.
- **Notes** — anything else. Prototype snippets that encode decisions go here.

## Rules

- **Link glossary terms.** When a term from `CONTEXT.org` appears in the PRD body, use `[[id:term-slug][Term]]`. Don't create new glossary entries — that's `grill-with-org`'s job.
- **No file paths or code snippets** in Problem/Solution/User Stories. They rot. Exception: prototype snippets in Notes/Decisions that encode a choice more precisely than prose.
- **`:ID:` prefix is `prd-`** — e.g. `prd-order-pipeline`. Stable, human-readable, greppable.
- **`:DATE:`** — inactive timestamp of when the PRD was created.
- **Tags** — owning context (`:ordering:`) and optionally topic tags.
- **Start as `TODO`**. The user flips to `APPROVED` when satisfied.

## Single vs multi-context repos

- **Single context:** one `prd.org` at the repo root.
- **Multiple contexts:** system-spanning PRDs in root `prd.org`, context-specific PRDs in `src/<context>/prd.org`. Tag every PRD with its context so agenda filtering works across files.

Detect structure the same way as `grill-with-org`: `CONTEXT-MAP.org` exists → multi-context; only root `CONTEXT.org` → single context; neither → single context, create lazily.
