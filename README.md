# Skills

Rhys Wheater's personal [Claude Code](https://code.claude.com) plugin **marketplace**. Skills are grouped into plugins by theme.

## Install

```
/plugin marketplace add RhysWheater/skills
/plugin install process@skills
```

## Add a new plugin

1. Create the plugin directory structure:
   ```
   plugins/<name>/
   ├── .claude-plugin/
   │   └── plugin.json
   └── skills/
       └── <skill-name>/
           └── SKILL.md
   ```
2. Register the plugin in `.claude-plugin/marketplace.json` — add an entry to the `plugins` array:
   ```json
   { "name": "<name>", "source": "./plugins/<name>" }
   ```
3. Run `./scripts/bump-and-publish.sh major` to bump, clear cache, and push.
4. In a new Claude Code session:
   ```
   /plugin marketplace update skills
   /plugin install <name>@skills
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

### `coding-style`

Language-specific coding patterns and idioms that linters cannot enforce — error handling strategies, control flow patterns, API design rules.

- **`python-patterns`** (`/coding-style:python-patterns`) — Extensible ruleset for Python code patterns. Currently covers: signal failure with exceptions (not return values/None).
- **`aws-patterns`** (`/coding-style:aws-patterns`) — Extensible ruleset for AWS infrastructure patterns. Currently covers: CloudWatch dimensions must add information (no redundant environment dimensions in single-env accounts).

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
    └── coding-style/
        ├── .claude-plugin/
        │   └── plugin.json      # plugin manifest
        └── skills/
            ├── python-patterns/
            │   └── SKILL.md     # extensible Python pattern rules
            └── aws-patterns/
                └── SKILL.md     # extensible AWS infrastructure rules
```
