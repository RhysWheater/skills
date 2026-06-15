# backlog.org format

All work items for a project live as top-level headlines in one file. Org's column view gives a dashboard of every task and its status; the agenda surfaces those still `TODO` or `IN-PROGRESS`. See [ORG-PRIMER.md](ORG-PRIMER.md) for any feature below.

## Why one file

Same reasoning as decisions.org and prd.org — one file lets column view aggregate all work items into a sortable table. Dependency links (`id:`) between tasks resolve instantly within one file. The agenda pulls everything together regardless, but having one file makes the column-view dashboard useful without setup.

## File header

```org
# Work items (vertical slices), one per top-level headline.
#+TITLE: Backlog
#+CATEGORY: backlog
#+FILETAGS: :backlog:
# Keywords: left of | = active (visible in agenda), right = resolved (hidden).
#+TODO: TODO(t) IN-PROGRESS(i) | DONE(d) CANCELLED(c)
# Column view: C-c C-x C-c on a headline for the table; q to exit.
#+COLUMNS: %40ITEM(Task) %TODO(Status) %TAGS %MODEL(Model) %BUDGET(Budget) %BLOCKED(Blocked by)
#+STARTUP: overview
```

- `TODO` — not started.
- `IN-PROGRESS` — actively being worked on.
- `DONE` — complete.
- `CANCELLED` — dropped.

## A work item

```org
* TODO Set up event bus  :ordering:afk:
  :PROPERTIES:
  :ID:       task-setup-event-bus
  :BLOCKED:  
  :PRD:      [[id:prd-order-pipeline]]
  :MODEL:    sonnet
  :BUDGET:   55k
  :END:
  Stand up the async event bus between Ordering and downstream consumers.
  Thin vertical slice: schema definition, publish on OrderPlaced, one consumer stub.
  - [ ] Event schema defined
  - [ ] OrderPlaced published on order creation
  - [ ] Consumer stub receives and logs
```

## Fields

- **TODO state** — `TODO` → `IN-PROGRESS` → `DONE` / `CANCELLED`. Only `TODO` and `IN-PROGRESS` appear in the agenda.
- **`:ID:`** — stable, human-readable, prefixed `task-` (e.g. `task-setup-event-bus`). Lets other tasks reference it in `:BLOCKED:`.
- **`:BLOCKED:`** — `[[id:task-other]]` link(s) to blocking tasks. Empty string if no blockers. Multiple blockers separated by space: `[[id:task-a]] [[id:task-b]]`.
- **`:PRD:`** — `[[id:prd-slug]]` link back to the parent PRD in `prd.org`. Omit if the work item came from conversation context rather than a PRD.
- **`:MODEL:`** — (`:afk:` only) model tier for execution: `opus`, `sonnet`, `haiku`, or `fable`. The cheapest tier that can reliably complete the task.
- **`:BUDGET:`** — (`:afk:` only) Fibonacci bucket: `8k | 13k | 21k | 34k | 55k | 89k | 144k | 233k`. Hard ceiling — the executing agent MUST stop immediately upon hitting this limit. If a task would need `233k+`, it must be decomposed further.
- **Tags:**
  - Context: `:ordering:`, `:billing:` — which bounded context this touches.
  - Type: `:afk:` (can be done without human interaction) or `:hitl:` (requires human decision/review). Prefer `:afk:` where possible.
  - Topic (optional): `:arch:`, `:data:`, `:integration:`.

## Body structure

The body has two parts:

1. **Description** (1–3 sentences): what this vertical slice delivers end-to-end. Describe behavior, not layer-by-layer implementation. Use `[[id:]]` links for glossary terms.
2. **Acceptance criteria** as an org checklist (`- [ ]`). Each criterion is independently verifiable. A completed slice is demoable or verifiable on its own.

No file paths or code snippets — they rot. Exception: prototype snippets that encode a decision more precisely than prose.

## Vertical slice rules

Each work item is a **tracer bullet** — a thin vertical slice cutting through ALL integration layers end-to-end:

- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests).
- A completed slice is demoable or verifiable on its own.
- Prefer many thin slices over few thick ones.
- Slices are either `:afk:` (implementable without human interaction) or `:hitl:` (requires a human decision, design review, or access grant). Tag accordingly.

## Dependency encoding

Blocking relationships use `:BLOCKED:` with `id:` links:

```org
* TODO Wire up read projections  :ordering:afk:
  :PROPERTIES:
  :ID:       task-wire-projections
  :BLOCKED:  [[id:task-setup-event-bus]]
  :PRD:      [[id:prd-order-pipeline]]
  :END:
```

Write items in dependency order (blockers first) so that by the time a blocked item is written, its blocker's `:ID:` already exists and the link resolves.

## Single vs multi-context repos

- **Single context:** one `backlog.org` at the repo root.
- **Multiple contexts:** system-spanning tasks in root `backlog.org`, context-specific tasks in `src/<context>/backlog.org`. Tag every task with its context so agenda filtering works across files.

Detect structure the same way as other org skills: `CONTEXT-MAP.org` exists → multi-context; otherwise single context, create lazily.
