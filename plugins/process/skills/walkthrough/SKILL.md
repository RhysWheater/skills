---
name: walkthrough
description: "Run a weekly architecture walkthrough of microservice repos: Claude investigates and draws diagrams, the user writes the prose, Claude reviews it. Use when the user says 'walkthrough', names repos for an architecture session, or opens ~/walkthroughs."
---

Goal: the user's **mental model** of the architecture, for better architecture-level judgement. Not encyclopedic code knowledge.

The user writes the documentation in their own words. Claude supplies diagrams and answers, then reviews.

## Hard rules

- **Prose belongs to the user.** Claude writes only diagram source (dot, PlantUML), resource-name tables, `# ERROR:` review marks, and open-question headings. Writing these directly into `walkthroughs.org` is pre-approved.
- Label every claim **verified** (read in code/config/CFN) or **inferred**. Say "unverified" openly.
- Diagrams render to **PNG**. Never SVG.
- Ask questions as plain text.

## Phases

1. **Setup.** Done when every repo path the user named is confirmed to exist and a `* TODO Walkthrough NN: <topic>` section lists them as `~/path`.
2. **Explore.** Answer the user's targeted questions; draw diagrams. Done when each question has a verified or labelled-inferred answer.
3. **User writes.** Claude waits. Offer a render check whenever a diagram was added.
4. **Review.** Read the user's prose against the code. Done when every claim is sorted into:
   - **Errors**: real misstatements. Mark in the org file as `# ERROR: ...`; leave the user's text untouched.
   - **Nuances**: true but incomplete or loose.
   - **Gaps**: optional omissions.
5. **Close.** Unresolved items become `** Open questions: ...` (short questions the user can reword). Queue next topics under `* Future Walkthroughs`.

## Exploring

- Start from README, tree, main app file, infra templates (CFN params give real resource names), CI workflows (manual vs automatic deploy), config JSON.
- **Follow the data**: input queue → processor → store → notification topic → consumers. Then follow **feedback loops**.
- Thin config repo over a shared library: read the library for semantics (merge, notify, TTL).
- User recalls history: check git log and workflows.
- Correct your own earlier answers openly when they were loose.
- Emphasise **why**, trade-offs, failure modes, where it hurts: contract duplication and **drift**, ordering/atomicity, manual operational steps.

## Diagrams

- `dot` for dependency/component maps: `#+begin_src dot :file img/<name>.png`
- PlantUML for sequence/component/C4: `#+begin_src plantuml :file img/<name>.png`
- Header defaults already set; add no `:cmdline`, no `:mkdirp`. User renders with `C-c C-c`. File has `#+STARTUP: hideblocks`.
- Under the dot overview, add a table mapping nodes to real AWS resource names; mark names absent from the repo.

## Org shape

`* TODO Walkthrough NN: <topic>` → repo list → overview dot + resource table → user prose → detail diagrams → `** Open questions: ...`. Then `* Future Walkthroughs` with `** <topic>` children. Model on `~/walkthroughs/walkthroughs.org`.
