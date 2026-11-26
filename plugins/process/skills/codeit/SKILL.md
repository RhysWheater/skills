---
name: codeit
description: "Build from Matt Pocock's planning artifacts (GLOSSARY.md, ADRs, spec, tickets with blocking edges) when another skill, such as /poteto-mode, drives the implementation. Load before turning a spec or tickets into code, naming things in a repo with a GLOSSARY.md, or working a ticket graph."
---

# Codeit

Reference for consuming Matt Pocock's planning artifacts during a build. Matt's skills (`/grill-with-docs`, `/to-spec`, `/to-tickets`) produced the plan. Another skill (e.g. `/poteto-mode`) owns the implementation method. This skill says how to respect the plan; it prescribes no build method.

## Subagents

Put this skill's absolute path in every subagent brief, after any line the driving skill requires first (e.g. poteto's `Read <path>/worker.md before anything else.`). Subagents start with fresh contexts and see nothing else from here.

## Read first

- `docs/agents/*.md`: tracker, labels, domain-doc layout, set by `/setup-matt-pocock-skills`. Follow them over anything assumed here.
- `GLOSSARY.md` (or `GLOSSARY-MAP.md` in a multi-context repo) and the ADR directory.
- The spec: build against it.
- The ticket(s): the unit of work.

Missing `docs/agents/`: tell the user to run `/setup-matt-pocock-skills`.

## Tickets

- A ticket is self-contained: what to build plus acceptance criteria. Its acceptance criteria are the completion bar; prove each one.
- Locate tickets per the tracker doc: local `.scratch/<feature>/issues/NN-slug.md` (blocking edges as text, blockers numbered first), or native tracker issues with blocking links.
- Work the **frontier**: tickets whose blockers are all done. Parallelise only across the frontier, one agent per ticket.
- On finish, update the ticket per the tracker doc: tick criteria and mark done locally, or close the issue natively.

## Glossary

- Use glossary terms exactly, in code, names, commits, and reports. Stretching a term muddies the domain.
- A needed concept missing from the glossary → add it with `/domain-modeling` (definition per its GLOSSARY-FORMAT).
  - Only the orchestrator (main chat) edits `GLOSSARY.md`. Subagents report the missing term and continue.
  - Surface every glossary change in the final report.

## ADRs and spec

A ticket or code that conflicts with an ADR or the spec means the design needs revisiting and a new decision. Stop that ticket, report the conflict, and wait. Do not deviate or work around it.

## Review

Run `/code-review` once, against the ticket and spec, for conformance (Spec axis). The driving skill's own verification, proof, and quality passes cover everything else; do not double-review.

## Upstream skills

`/to-spec`, `/to-tickets`, `/implement`, `/implement-spec` are user-typed only. Name them to the user; never call them. The build step here replaces `/implement` and `/implement-spec`.
