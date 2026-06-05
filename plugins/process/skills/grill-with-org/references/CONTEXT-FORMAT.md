# CONTEXT.org format

The glossary, as an Org file. Each term is a headline carrying data (ID, aliases-to-avoid, tags) and `id:` links to related terms, so the glossary is a navigable graph rather than a flat list. See [ORG-PRIMER.md](ORG-PRIMER.md) for any feature below.

## Structure

```org
# Glossary for the {Context Name} context. Terms only — no implementation detail.
#+TITLE: {Context Name} — Language
#+CATEGORY: {context}
#+STARTUP: showall

{One or two sentence description of what this context is and why it exists.}

* Order  :ordering:
  :PROPERTIES:
  :ID:     ord-order
  :AVOID:  purchase, transaction
  :END:
  A request placed by a [[id:cust-customer][Customer]] for goods or services.

* Invoice  :billing:
  :PROPERTIES:
  :ID:     bil-invoice
  :AVOID:  bill, payment request
  :END:
  A request for payment sent to a [[id:cust-customer][Customer]] after delivery.

* Customer  :ordering:
  :PROPERTIES:
  :ID:     cust-customer
  :AVOID:  client, buyer, account
  :END:
  A person or organization that places [[id:ord-order][Orders]].

* TODO [#A] Clarify "Account"
  Used to mean both [[id:cust-customer][Customer]] and the login User. Which is it?
  Resolve into a defined term and drop this TODO.
```

## Rules

- **One headline per term.** The headline text is the canonical term. `:AVOID:` lists the aliases not to use — be opinionated; when several words mean one thing, pick the best and relegate the rest.
- **Definitions are tight.** One or two sentences in the body. Define what it IS, not what it does.
- **Show relationships as `id:` links.** When a definition references another term, link it (`[[id:other-term][Other Term]]`). This is the whole point of using org — relationships become followable edges. Give every term a stable, human-readable `:ID:` (`ord-order`, not a UUID).
- **Tag by context (and topic if useful).** Single-context repos can use one tag; multi-context repos must tag each term with its owning context so the agenda/sparse-tree can filter.
- **Unresolved ambiguities are `TODO` headlines.** When a term is used ambiguously and not yet settled, capture it as `* TODO [#A] Clarify "X"` with a one-line note. It surfaces in the agenda. When resolved, convert it into a normal defined term (or fold it into an existing one) and remove the TODO.
- **Only context-specific terms.** General programming concepts (timeouts, retries, generic utility patterns) don't belong even if used heavily. Ask: is this unique to this domain, or general? Only the former.
- **Group with sub-headlines** when natural clusters emerge; a flat list is fine if all terms cohere.
- **Example dialogue.** End the file with a short dialogue between a dev and a domain expert, under a `* Example dialogue` headline, demonstrating how the terms interact and where the boundaries lie.
- **No implementation detail.** This is a glossary, not a spec or scratch pad.

## Single vs multi-context repos

**Single context (most repos):** one `CONTEXT.org` at the repo root.

**Multiple contexts:** a `CONTEXT-MAP.org` at the root lists the contexts, where each lives, and how they relate. Use `id:` links so the map is navigable:

```org
#+TITLE: Context Map
#+STARTUP: showall

* Contexts
- [[file:src/ordering/CONTEXT.org][Ordering]] — receives and tracks customer orders
- [[file:src/billing/CONTEXT.org][Billing]] — generates invoices and processes payments
- [[file:src/fulfillment/CONTEXT.org][Fulfillment]] — warehouse picking and shipping

* Relationships
- *Ordering → Fulfillment*: Ordering emits ~OrderPlaced~; Fulfillment consumes it to start picking.
- *Fulfillment → Billing*: Fulfillment emits ~ShipmentDispatched~; Billing consumes it to invoice.
- *Ordering ↔ Billing*: shared ~CustomerId~ and ~Money~ types.
```

Infer the structure:

- `CONTEXT-MAP.org` exists → multiple contexts; read it to find them.
- Only a root `CONTEXT.org` → single context.
- Neither → create a root `CONTEXT.org` lazily when the first term resolves.

When multiple contexts exist, infer which one the current topic belongs to. If unclear, ask.
