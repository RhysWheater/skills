# Skills

Rhys Wheater's personal [Claude Code](https://code.claude.com) plugin **marketplace**. Skills are grouped into plugins by theme.

## Install

```
/plugin marketplace add RhysWheater/skills
/plugin install process@skills
```

## Update after changing skills

The plugin system caches by version number. Adding or changing skills without bumping the version means Claude Code keeps serving the stale cache. Run this after any change:

```bash
./scripts/bump-and-publish.sh        # default: patch bump
./scripts/bump-and-publish.sh minor  # for new skills
./scripts/bump-and-publish.sh major  # for breaking changes
```

This bumps every `plugin.json` version, nukes the local cache (`~/.claude/plugins/cache/skills/`), commits, and pushes. Start a new Claude Code session afterwards.

### Manual alternative (not recommended)

```
/plugin marketplace update skills
/plugin update process@skills
```

If that still doesn't work, force reinstall:

```
/plugin uninstall process@skills
/plugin install process@skills
```

## Plugins

### `process`

Skills about *how to work* — way of working, planning, and method. Anchored on the Disciplined Agile toolkit.

- **`decide-wow`** (`/process:decide-wow`) — Decide or reassess a project's Way of Working through a disciplined one-question-at-a-time interview. Assesses project state, reasons from the uncertainty profile to a DA lifecycle, names the riskiest assumption, designs a falsifiable first experiment, and captures decisions inline into `WAYS-OF-WORKING.md`, ADRs, and `CONTEXT.md`.
- **`grill-with-org`** (`/process:grill-with-org`) — Stress-test a plan against your project's language and documented decisions, one question at a time, capturing the results as **Emacs Org-mode** living documentation (`CONTEXT.org`, `decisions.org`). Treats docs as a queryable data model — headlines carry IDs, property drawers, tags and TODO/agenda state — so the glossary becomes a navigable graph and decisions become a column-view table.
- **`to-prd-with-org`** (`/process:to-prd-with-org`) — Synthesize conversation context into a structured PRD in `prd.org` with TODO lifecycle (`DRAFT` → `READY` → `DONE`), `id:` links to glossary and decisions, column-view dashboard, and agenda integration.
- **`to-issues-with-org`** (`/process:to-issues-with-org`) — Break a plan or PRD into independently-grabbable vertical-slice work items in `backlog.org` with TODO states, `id:`-linked dependency graph, `:hitl:`/`:afk:` tags, and a quiz loop before writing.

### `gtd`

Skills for operating a personal, ADHD-aware org-mode GTD kanban board. Run from within the gtd directory.

- **`review`** (`/gtd:review`) — Run the weekly board-review ceremony over the org-mode kanban, one question at a time with a recommended action each: reconcile in-flight projects against reality and sweep PARKED, check WIP and slow-burn-category starvation, promote on-deck work, nudge time-sensitive and forgotten items, batch trivial errands into startable projects, and capture new items. Encodes the *method* (and its ADHD rationale) — the task content and design rationale stay in the gtd directory's own `decisions.org` / `CONTEXT.org` / memory, which the skill reads live.

## Layout

```
skills/
├── .claude-plugin/
│   └── marketplace.json        # marketplace manifest
├── scripts/
│   └── bump-and-publish.sh     # version bump + cache clear + push
└── plugins/
    ├── process/
    │   ├── .claude-plugin/
    │   │   └── plugin.json      # plugin manifest
    │   └── skills/
    │       ├── decide-wow/
    │       │   ├── SKILL.md
    │       │   └── references/  # DA toolkit + doc formats
    │       ├── grill-with-org/
    │       │   ├── SKILL.md
    │       │   └── references/  # org primer + CONTEXT.org / decisions.org formats
    │       ├── to-prd-with-org/
    │       │   ├── SKILL.md
    │       │   └── references/  # org primer + PRD format + decisions format
    │       └── to-issues-with-org/
    │           ├── SKILL.md
    │           └── references/  # org primer + backlog format + decisions format
    └── gtd/
        ├── .claude-plugin/
        │   └── plugin.json      # plugin manifest
        └── skills/
            └── review/
                └── SKILL.md     # the weekly board-review ceremony
```
