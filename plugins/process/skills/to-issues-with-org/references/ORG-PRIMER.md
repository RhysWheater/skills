# Org-mode features this skill relies on

This skill emits Org files that double as a queryable data model. This primer covers exactly the features the two file formats use, why each one matters, and how to teach it to a user who is comfortable-but-learning. Keep explanations to one line in-file (`# ` comment) and one line in chat.

## Headlines and tags

A headline starts with one or more `*`. Tags are colon-delimited and right-aligned on the headline line:

```org
* Order  :ordering:domain:
```

Tags group and filter. In this skill they mark **which bounded context** a task belongs to (`:ordering:`, `:billing:`), the **topic** (`:arch:`, `:integration:`), and the **type** (`:hitl:`, `:afk:`). The user can build a sparse tree of one tag with `C-c \` or filter the agenda by tag with `/`.

`#+FILETAGS: :backlog:` at the top of a file applies a tag to *every* headline in it — use it so a whole file is filterable at once.

## Property drawers

A `:PROPERTIES:`/`:END:` block immediately under a headline holds key–value metadata that tools can query but that stays out of the prose:

```org
* TODO Set up event bus  :ordering:afk:
  :PROPERTIES:
  :ID:       task-setup-event-bus
  :BLOCKED:  
  :PRD:      [[id:prd-order-pipeline]]
  :END:
```

Properties are the heart of "org as data". This skill uses:

- `:ID:` — a stable unique identifier for the headline (see below).
- `:BLOCKED:` — `[[id:]]` link(s) to blocking tasks. Empty if no blockers.
- `:PRD:` — `[[id:]]` link to the parent PRD in `prd.org`.

Custom property names are free-form; pick stable ones and reuse them so column view and `org-map-entries` can rely on them.

## IDs and `id:` links — the dependency graph

Give a headline a stable ID in its property drawer:

```org
* TODO Wire up read projections  :ordering:afk:
  :PROPERTIES:
  :ID:  task-wire-projections
  :END:
```

Then link to it from anywhere — another task's `:BLOCKED:` property, a PRD, prose — with an `id:` link:

```org
:BLOCKED:  [[id:task-setup-event-bus]]
```

`C-c C-o` on the link jumps straight to that headline, even across files. This turns a flat task list into a **navigable dependency graph**: every blocking relationship is a real, followable edge. Prefer human-readable IDs (`task-setup-event-bus`) over random UUIDs — they're greppable and stable.

> Setup the user may need once: `id:` links resolve via an ID location cache. If a link won't follow, `M-x org-id-update-id-locations` rebuilds it. Mention this the first time you create a cross-file link.

## TODO keywords — task lifecycle

A headline can carry a TODO keyword right after the stars. Define the allowed sequence per-file:

```org
#+TODO: TODO(t) IN-PROGRESS(i) | DONE(d) CANCELLED(c)
```

Words before the `|` are "not done" (show as actionable); words after are "done". `C-c C-t` cycles them.

Because these are real TODO states, anything not-done appears in `org-agenda` as work to do. That's what makes the backlog "living".

Priorities `[#A]`/`[#B]`/`[#C]` can be added (`* TODO [#A] Set up event bus`) to sort the most critical tasks to the top of the agenda.

## Column view — the backlog table

`#+COLUMNS:` defines a spreadsheet-style view over headlines and their properties:

```org
#+COLUMNS: %40ITEM(Task) %TODO(Status) %TAGS %BLOCKED(Blocked by)
```

With the cursor on a headline, `C-c C-x C-c` opens the column view: every task rendered as a sortable table of Status / Tags / Blockers. `q` exits. The numbers are column widths; the `(Label)` renames the column header.

## Agenda

`org-agenda` aggregates TODO items across files listed in `org-agenda-files`. With the TODO keywords above, `TODO` tasks become agenda entries. Two things to tell the user once per repo:

- Add the file: `(add-to-list 'org-agenda-files "backlog.org")` (or a directory).
- `#+CATEGORY:` at the top of a file labels its entries in the agenda (e.g. `#+CATEGORY: backlog`).

## Putting it together

The payoff: a reader (or a future agent) can `C-c C-x C-c` to see every task and its status as a table, `C-c C-o` to follow blocking links and jump to the parent PRD, and open their agenda to see all unblocked `TODO` items as actionable work — none of which a flat issue list can do. When you use a feature for the first time in a session, leave a one-line `# ` comment in the file and say one line in chat about what it unlocks.
