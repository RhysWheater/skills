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

## Layout

```
skills/
├── .claude-plugin/
│   └── marketplace.json        # marketplace manifest
└── plugins/
    └── process/
        ├── .claude-plugin/
        │   └── plugin.json      # plugin manifest
        └── skills/
            ├── decide-wow/
            │   ├── SKILL.md
            │   └── references/  # DA toolkit + doc formats
            └── grill-with-org/
                ├── SKILL.md
                └── references/  # org primer + CONTEXT.org / decisions.org formats
```
