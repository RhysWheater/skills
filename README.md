# Skills

Rhys Wheater's personal [Claude Code](https://code.claude.com) plugin **marketplace**. Skills are grouped into plugins by theme.

## Install

```
/plugin marketplace add RhysWheater/skills
/plugin install process@skills
```

## Plugins

### `process`

Skills about *how to work* — way of working, planning, and method. Anchored on the Disciplined Agile toolkit.

- **`decide-wow`** (`/process:decide-wow`) — Decide or reassess a project's Way of Working through a disciplined one-question-at-a-time interview. Assesses project state, reasons from the uncertainty profile to a DA lifecycle, names the riskiest assumption, designs a falsifiable first experiment, and captures decisions inline into `WAYS-OF-WORKING.md`, ADRs, and `CONTEXT.md`.
- **`grill-with-org`** (`/process:grill-with-org`) — Stress-test a plan against your project's language and documented decisions, one question at a time, capturing the results as **Emacs Org-mode** living documentation (`CONTEXT.org`, `decisions.org`). Treats docs as a queryable data model — headlines carry IDs, property drawers, tags and TODO/agenda state — so the glossary becomes a navigable graph and decisions become a column-view table.

### `gtd`

Skills for operating a personal, ADHD-aware org-mode GTD kanban board. Run from within the gtd directory.

- **`review`** (`/gtd:review`) — Run the weekly board-review ceremony over the org-mode kanban, one question at a time with a recommended action each: reconcile in-flight projects against reality and sweep PARKED, check WIP and slow-burn-category starvation, promote on-deck work, nudge time-sensitive and forgotten items, batch trivial errands into startable projects, and capture new items. Encodes the *method* (and its ADHD rationale) — the task content and design rationale stay in the gtd directory's own `decisions.org` / `CONTEXT.org` / memory, which the skill reads live.

## Layout

```
skills/
├── .claude-plugin/
│   └── marketplace.json        # marketplace manifest
└── plugins/
    ├── process/
    │   ├── .claude-plugin/
    │   │   └── plugin.json      # plugin manifest
    │   └── skills/
    │       ├── decide-wow/
    │       │   ├── SKILL.md
    │       │   └── references/  # DA toolkit + doc formats
    │       └── grill-with-org/
    │           ├── SKILL.md
    │           └── references/  # org primer + CONTEXT.org / decisions.org formats
    └── gtd/
        ├── .claude-plugin/
        │   └── plugin.json      # plugin manifest
        └── skills/
            └── review/
                └── SKILL.md     # the weekly board-review ceremony
```
