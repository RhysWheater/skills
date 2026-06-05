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
# Decision lifecycle: cycle with C-c C-t. Left of | = open, right = closed.
#+TODO: PROPOSED ACCEPTED | DEPRECATED SUPERSEDED
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

- **TODO state** — `PROPOSED` when first raised, `ACCEPTED` once settled; later `DEPRECATED` or `SUPERSEDED`. This is live data: `PROPOSED` decisions show up in the agenda as open questions.
- **`:ID:`** — stable, human-readable (`dec-<slug>`). Lets other decisions and glossary terms link to it.
- **`:DATE:`** — inactive timestamp `[YYYY-MM-DD]` of when the decision was made (inactive so it doesn't act as an agenda deadline).
- **Tags** — owning context (`:ordering:`) and topic (`:arch:`, `:integration:`, `:data:`). `:decision:` comes free from `#+FILETAGS:`.

## Optional sub-detail

Most decisions need nothing more. When a rejection or consequence is genuinely worth remembering, add it inline in the body or as a sub-headline — don't impose a template:

```org
* ACCEPTED Communicate between contexts via domain events  :integration:arch:
  :PROPERTIES:
  :ID:    dec-events-not-http
  :DATE:  [2026-06-05]
  :END:
  Ordering and Billing integrate via async domain events, not synchronous HTTP,
  to decouple deployment and tolerate partial outages.
** Considered: synchronous REST
   Rejected — couples availability; a Billing outage would block order placement.
```

## When to record a decision

All three must hold (same bar as a good ADR):

1. **Hard to reverse** — meaningful cost to change later.
2. **Surprising without context** — a future reader will wonder "why this way?"
3. **The result of a real trade-off** — genuine alternatives existed and one was chosen for specific reasons.

If easy to reverse, skip it — you'll just reverse it. If unsurprising, nobody wonders why. If there was no alternative, there's nothing to record beyond "we did the obvious thing."

### What qualifies

- **Architectural shape** — "monorepo"; "event-sourced write model, projected read model".
- **Integration patterns between contexts** — events vs synchronous HTTP.
- **Technology choices carrying lock-in** — database, message bus, auth provider, deploy target. Not every library — the ones that'd take a quarter to swap.
- **Boundary/scope decisions** — "Customer data is owned by the Customer context; others reference by ID only." The explicit no's matter as much as the yes's.
- **Deliberate deviations from the obvious path** — "manual SQL instead of an ORM because X." Stops the next engineer from "fixing" something deliberate.
- **Constraints invisible in the code** — "no AWS, for compliance"; "sub-200ms responses, per partner contract".
- **Non-obvious rejected alternatives** — picked REST over GraphQL for subtle reasons? Record it, or someone re-proposes GraphQL in six months.

## Numbering

Don't. Identity comes from the `:ID:`, not a sequence number — so there's no renumbering when decisions are added or reordered, and links never break. (If the user wants ADR-style numbers for external reference, add a `:ADR:` property; the ID stays canonical.)

## Multi-context repos

System-wide decisions go in the root `decisions.org`. Context-specific decisions go in that context's `src/<context>/decisions.org`. Tag every decision with its context either way, so an agenda spanning all decision files stays filterable.
