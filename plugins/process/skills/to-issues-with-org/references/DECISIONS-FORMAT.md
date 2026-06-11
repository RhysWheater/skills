# decisions.org format

The org-native replacement for a `docs/adr/` directory of markdown ADRs. **Every architectural decision is a headline in one file**, so org's column view gives you a sortable table of all decisions and their status, and `org-agenda` surfaces the ones still `PROPOSED`. See [ORG-PRIMER.md](ORG-PRIMER.md) for any feature below.

## Why one file, not one-file-per-ADR

A markdown `docs/adr/0001-*.md` directory is just a pile of prose — you cannot see "all accepted decisions touching billing" without opening each file. In org, headlines + properties make the set queryable: `C-c C-x C-c` on the top headline renders every decision as a table (status, date, tags); the agenda lists every un-accepted one. Keep them together to get this for free.

## File header

```org
# All architectural decisions for this repo/context, one per headline.
#+TITLE: Decisions
#+CATEGORY: {context}
#+FILETAGS: :decision:
# Keywords: left of | = open (visible in agenda), right = resolved (hidden).
# TODO = open work (questions, blockers, investigations). PROPOSED = decision under consideration.
# DONE = work completed. ACCEPTED = decision settled. SUPERSEDED/REJECTED = decision closed.
#+TODO: TODO(t) PROPOSED(p) | DONE(d) ACCEPTED(a) SUPERSEDED(s) REJECTED(r)
# Column view: put cursor on a headline and press C-c C-x C-c for the table; q to exit.
#+COLUMNS: %38ITEM(Decision) %TODO(Status) %DATE %TAGS
#+STARTUP: showall
```

## A decision

```org
* ACCEPTED Event-source the write model  :ordering:arch:
  :PROPERTIES:
  :ID:    dec-event-sourced-write-model
  :DATE:  [2026-06-05]
  :END:
  The write model is event-sourced; the read model is projected into Postgres.
  Chosen for a full audit trail and temporal queries, accepting the added
  projection complexity. Alternatives: CRUD (rejected — loses history),
  CDC (rejected — couples read/write schemas).
```

The body is **1–3 sentences**: context, decision, and why. A decision can be a single paragraph — the value is recording *that* a choice was made and *why*, not filling sections. Add a `[[id:...]]` link to any glossary term or related decision it touches.

## Fields

- **TODO state** — Two kinds of headline share this file:
  - *Decisions:* `PROPOSED` when first raised, `ACCEPTED` once settled, `SUPERSEDED` if replaced, `REJECTED` if shot down.
  - *Work items* (open questions, blockers, follow-up investigations spawned by decisions): `TODO` when open, `DONE` when resolved. Use `:ID:` prefix `q-` (not `dec-`) and link to the related decision.
  Only `TODO` and `PROPOSED` (left of `|`) appear in the project agenda — everything else is resolved and hidden.
- **`:ID:`** — stable, human-readable (`dec-<slug>`). Lets other decisions and glossary terms link to it.
- **`:DATE:`** — inactive timestamp `[YYYY-MM-DD]` of when the decision was made (inactive so it doesn't act as an agenda deadline).
- **Tags** — owning context (`:ordering:`) and topic (`:arch:`, `:integration:`, `:data:`). `:decision:` comes free from `#+FILETAGS:`.

## When to record a decision

All three must hold (same bar as a good ADR):

1. **Hard to reverse** — meaningful cost to change later.
2. **Surprising without context** — a future reader will wonder "why this way?"
3. **The result of a real trade-off** — genuine alternatives existed and one was chosen for specific reasons.

If easy to reverse, skip it — you'll just reverse it. If unsurprising, nobody wonders why. If there was no alternative, there's nothing to record beyond "we did the obvious thing."
