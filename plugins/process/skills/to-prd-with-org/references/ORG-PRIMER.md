# Org-mode features this skill relies on

This skill emits Org files that double as a queryable data model. This primer covers exactly the features the two file formats use and why each one matters.

## Headlines and tags

A headline starts with one or more `*`. Tags are colon-delimited and right-aligned on the headline line:

```org
* Order  :ordering:domain:
```

Tags group and filter. In this skill they mark **which bounded context** a term/decision belongs to (`:ordering:`, `:billing:`) and the **topic** (`:arch:`, `:domain:`, `:integration:`). The user can build a sparse tree of one tag with `C-c \` or filter the agenda by tag with `/`.

`#+FILETAGS: :decision:` at the top of a file applies a tag to *every* headline in it — use it so a whole file is filterable at once.

## Property drawers

A `:PROPERTIES:`/`:END:` block immediately under a headline holds key–value metadata that tools can query but that stays out of the prose:

```org
* Order  :ordering:
  :PROPERTIES:
  :ID:       ord-order
  :AVOID:    purchase, transaction
  :DATE:     [2026-06-05]
  :END:
  An request placed by a Customer for goods.
```

Properties are the heart of "org as data". This skill uses:

- `:ID:` — a stable unique identifier for the headline (see below).
- `:AVOID:` — glossary aliases that should NOT be used (the org-native version of grill-with-docs' "_Avoid_:" line).
- `:DATE:` — when a decision was made, as an inactive timestamp `[YYYY-MM-DD]` (inactive = won't clutter the agenda as a deadline).

Custom property names are free-form; pick stable ones and reuse them so column view and `org-map-entries` can rely on them.

## IDs and `id:` links — the glossary-as-graph

Give a headline a stable ID in its property drawer:

```org
* Customer  :ordering:
  :PROPERTIES:
  :ID:  cust-customer
  :END:
```

Then link to it from anywhere — another term, a decision, prose — with an `id:` link:

```org
An [[id:cust-customer][Customer]] places an [[id:ord-order][Order]].
```

`C-c C-o` on the link jumps straight to that headline, even across files. This is what turns a flat glossary into a **navigable graph**: every relationship between terms is a real, followable edge, not just bold text. Prefer human-readable IDs (`ord-order`, `cust-customer`) over random UUIDs — they're greppable and stable.

> Setup the user may need once: `id:` links resolve via an ID location cache. If a link won't follow, `M-x org-id-update-id-locations` rebuilds it. Mention this the first time you create a cross-file link.

## TODO keywords

A headline can carry a TODO keyword right after the stars. Define the allowed sequence per-file:

```org
#+TODO: TODO(t) | APPROVED(a) CANCELLED(c)
```

Words before the `|` are "open" (show as actionable); words after are "resolved". All open items use a single `TODO` state — find them across the project with `grep -r "^\* TODO" .`.

Each file type has its own closed states:

- **prd.org:** `TODO` → `APPROVED` / `CANCELLED`.
- **decisions.org:** `TODO` → `ACCEPTED` / `DEPRECATED` / `SUPERSEDED`.
- **CONTEXT.org:** `TODO` marks an unresolved ambiguity. Drop the keyword once resolved.

## Column view — the decisions table

`#+COLUMNS:` defines a spreadsheet-style view over headlines and their properties:

```org
#+COLUMNS: %35ITEM(Decision) %TODO(Status) %DATE %TAGS
```

With the cursor on a headline, `C-c C-x C-c` opens the column view: every decision rendered as a sortable table of Status / Date / Tags. `q` exits. This is the single biggest reason to keep all decisions in one file rather than one-file-per-ADR — you get an at-a-glance dashboard of every architectural decision for free. The numbers are column widths; the `(Label)` renames the column header.

## Agenda

`org-agenda` aggregates TODO items across files listed in `org-agenda-files`. With the TODO keywords above, `TODO` items become agenda entries.

## Inactive timestamps

`[2026-06-05]` (square brackets) is an *inactive* timestamp — recorded for data, ignored by the agenda's date scan. `<2026-06-05>` (angle brackets) is *active* and would show as a scheduled/deadline item. Decision dates use **inactive** form — they're a record, not a deadline.

