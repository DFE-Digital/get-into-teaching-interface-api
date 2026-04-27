---
date: 2026-04-24
topic: crm-adapter-pattern
focus: Adapter pattern design for the CRM client layer
---

# Ideation: CRM Adapter Pattern

## Codebase Context

`get-into-teaching-interface-api` is a Rails 8.1 API gateway replacing a C# app.
It sits between upstream Ruby client services (which use a shared Ruby client gem)
and the Dynamics 365 CRM API. The app is greenfield — `lib/` is empty, no CRM code
exists yet, and the Dynamics 365 API itself is still under active development.

Stack: Ruby on Rails 8.1, PostgreSQL, Solid Queue (async jobs), Solid Cache,
RSpec + FactoryBot. DFE Rails template conventions apply throughout.

**Proposed architecture (from team discussions):**

```
Service → GetIntoTeachingApiClient → Controller
       → CRMClient → Dynamics365Adapter → Dynamics365 CRM
```

`CRMClient` defines the contract (data shape). Adapters implement that contract
and handle HTTP calls and mild transformation. The goal is: swap the CRM without
touching controllers; test without hitting the real CRM; isolate transformation
logic in one place.

**Key constraints:**
- Dynamics 365 API is still being built — code must work before the real API is live
- Transformation logic is deliberately being moved *into* this service (away from the CRM)
- Both async (Solid Queue) and synchronous request paths are required

---

## Ranked Ideas

### 1. Adapter Registry with Environment-Driven Selection

**Description:** Introduce a thin registry — `CRM.adapter` — that resolves the
active adapter from an environment variable or Rails config. Defaults to a
`StubAdapter` in test and development environments, and `Dynamics365Adapter` in
production. Switching the entire CRM backend is a single config change.

**Rationale:** The Dynamics 365 API is still being built, so a period exists where
all code must run against a stub. Without a registry, this "mock phase" produces
`if Rails.env.test?` branches scattered across the codebase that are painful to
remove later. With a registry, every controller and job written before the real
API exists will automatically pick up the live adapter on deploy day with zero
code changes.

**Downsides:** Adds a level of indirection when reading code — `CRM.adapter.regions`
requires a hop to understand what `CRM.adapter` resolves to. The team needs to
decide whether to use a global singleton or per-request configuration.

**Confidence:** 92%
**Complexity:** Low
**Status:** Unexplored

---

### 2. Normalised Error Taxonomy at the Adapter Boundary

**Description:** Define a closed hierarchy of CRM error classes —
`CRM::NotFoundError`, `CRM::ValidationError`, `CRM::UnavailableError`,
`CRM::RateLimitError`. Adapters raise these; raw `Faraday::Error` and HTTP status
codes never reach controllers.

**Rationale:** This affects every single controller. Established now, handling a
missing CRM record is a one-liner everywhere (`rescue CRM::NotFoundError → 404`).
Retrofitted after fifteen controllers exist means touching all of them. The existing
`errors_controller.rb` already covers 404/422/429/500 at the HTTP level — this is
the CRM equivalent at the domain level. The C# predecessor's unmaintainability
likely included exactly this kind of drift between error-handling styles.

**Downsides:** Adds a mapping step in the adapter for each error type. New
Dynamics 365-specific errors may not map cleanly and require taxonomy extension over
time.

**Confidence:** 88%
**Complexity:** Low
**Status:** Unexplored

---

### 3. Typed Response Value Objects as the Contract Boundary

**Description:** `CRMClient` methods return `Data.define`-based value objects
(e.g. `CRMClient::TeachingEvent::Region`) rather than raw hashes. The adapter's
job is to construct these objects from the CRM payload. Controllers receive
named fields, never string-keyed hashes.

**Rationale:** This makes "CRMClient defines the contract" concrete and enforceable
rather than a convention. String-keyed hash leakage is the most common source of
invisible coupling in adapter-pattern Ruby codebases. `Data.define` (stable in Ruby
3.2, shipped with Rails 8.1) makes frozen value objects trivial. Establishing this
before any response objects are written means zero migration cost.

**Downsides:** `Data.define` objects are immutable — incrementally building a
response requires a separate builder step. Adds a type definition file per entity.

**Confidence:** 90%
**Complexity:** Low–Medium
**Status:** Unexplored

---

### 4. RSpec Shared Examples as Machine-Checked Contract

**Description:** Define the `CRMClient` contract as an RSpec shared example group
(`it_behaves_like "a CRM adapter"`). Every adapter — `Dynamics365Adapter`,
`StubAdapter`, any future CRM — must pass it. Adding a new operation to the
contract automatically requires adapter coverage; CI fails if any adapter omits it.

**Rationale:** Without this, contract drift is invisible. When a new CRM operation
is added to `CRMClient`, nothing breaks in `StubAdapter` — it silently omits the
behaviour and tests stay green. The shared example group makes the contract
machine-checkable at a low one-time investment that compounds across every
subsequent operation added.

**Downsides:** Shared examples can become unwieldy if not structured carefully.
Requires discipline in what the shared example actually asserts (return shape vs
method existence). Some upfront investment to write well.

**Confidence:** 85%
**Complexity:** Low
**Status:** Unexplored

---

### 5. Codec Layer — Separate HTTP Dispatch from Transformation

**Description:** `Dynamics365Adapter::TeachingEvent` handles only HTTP: request
dispatch and raw response capture. A separate `Dynamics365Codec::TeachingEvent`
handles field mapping in both directions (OData field names → Ruby domain names,
option set values, date coercions). The adapter calls the codec; the codec is
independently unit-testable as a pure function.

**Rationale:** Transformation logic is the thing that changes most as the CRM API
evolves — OData field names, option set integer values, date formats. Mixing it
with HTTP dispatch means HTTP stubs are needed to test field mapping. Separating
them makes transformation a pure function (raw hash in → value object out) testable
with zero HTTP setup. The `Dynamics365Codec` namespace fits naturally alongside the
existing `CRMClient` and `Dynamics365Adapter` namespaces already proposed.

**Downsides:** Adds a third namespace layer. May feel like over-engineering for
simple adapters with minimal transformation. Requires team agreement on what counts
as "transformation" versus "HTTP response parsing."

**Confidence:** 78%
**Complexity:** Medium
**Status:** Unexplored

---

### 6. Idempotency Keys for Async Writes

**Description:** Before enqueuing a Solid Queue write job, generate and store an
idempotency key in PostgreSQL. The adapter passes this key to the CRM API on every
attempt; retries reuse the same key. No duplicate CRM records are created on
transient failures.

**Rationale:** Solid Queue retries failed jobs. Without idempotency keys, a
transient `503` from Dynamics 365 creates duplicate CRM records — a data integrity
problem that is hard to clean up after the fact. PostgreSQL for key storage is
already present. This is the kind of infrastructure that is cheap to establish
before the first async write job is written and very expensive to retrofit across
many jobs.

**Downsides:** Requires a schema migration for key storage. Dynamics 365 support
for idempotency semantics (via duplicate detection rules or the `Prefer` header)
needs verification against the actual API. Adds per-job overhead.

**Confidence:** 80%
**Complexity:** Medium
**Status:** Unexplored

---

### 7. Question the CRMClient Layer — Is It Earning Its Place?

**Description:** The proposed two-tier design (Controller → CRMClient → Adapter)
has `CRMClient` as a delegation-only layer with no logic of its own. If CRMClient
purely proxies to the adapter, it provides ceremony without substance. This
question is worth resolving deliberately before the pattern calcifies.

`CRMClient` earns its place if it: (a) holds the value object type definitions
that make the contract concrete; (b) applies cross-cutting concerns (error
normalisation, caching); (c) does version negotiation before delegating. If it
does none of these and just delegates, collapsing the two layers into a single
well-namespaced adapter simplifies the stack without losing swappability.

**Rationale:** The team's own note that this "may be overkill" flags the concern
explicitly. This is a cheap decision to make now and expensive to reverse once
dozens of operations exist across both layers.

**Downsides:** Raising this risks creating unnecessary doubt in a team that has
already converged on an approach. If CRMClient does accumulate meaningful
cross-cutting logic, the question answers itself.

**Confidence:** 70%
**Complexity:** Low (design question, not implementation work)
**Status:** Unexplored

---

## Rejection Summary

| # | Idea | Reason Rejected |
|---|------|-----------------|
| 1 | No canonical location for CRM code | Convention problem; belongs in AGENTS.md, not architecture |
| 2 | Generator/template for new CRM operations | Tooling that follows the pattern decision, not informs it |
| 3 | Field mapping invisibility at debug time | Solved by codec layer + value objects; not a standalone idea |
| 4 | Structured logging with adapter context | Implementation detail that falls out of good adapter design |
| 5 | Async vs sync operation visibility | Documentation concern, not adapter architecture |
| 6 | Schema discovery Rake task | Timing-dependent, narrow, low leverage at this stage |
| 7 | Self-registering adapters | Duplicates adapter registry; adds grep-defeating magic |
| 8 | Functional adapters (class methods only) | Implementation style, not an architectural idea |
| 9 | OpenAPI spec as true contract | No actionable implementation path for this specific design |
| 10 | Adapters upstream in consumer services | Contradicts the team's stated decision |
| 11 | Real risk is versioning not CRM replacement | An insight worth noting, not an actionable idea |
| 12 | Callable modules instead of classes | Minor style variant, not architecturally distinct |
| 13 | Zero-persistence gateway stance | Reinforces existing intent; better recorded as an ADR |
| 14 | Versioned adapter/capability declaration | Premature — solve when the API stabilises |
| 15 | Solid Cache in front of adapter | Refinement that follows from boundary decisions; not standalone |
| 16 | Auto-generate null adapter from interface | Merged into registry + shared examples |
| 17 | StubAdapter with fixture-quality fidelity | Merged into adapter registry idea |
| 18 | Solid Queue owns retry, not adapter | Follows from error taxonomy + registry; not standalone |
| 19 | VCR/record-replay adapter mode | Adds gem complexity; shared examples + stub achieves similar coverage |
| 20 | Lint rule preventing direct adapter references | Derivative; follows from establishing the architecture |
| 21 | Command/query objects as controller boundary | Scope creep beyond the adapter pattern |
| 22 | Correlation ID threading | Best-practice implementation detail, not adapter architecture |
| 23 | Operations-based adapter decomposition | Significant pivot from entity-based sketch; better explored in brainstorm |

---

## Session Log

- 2026-04-24: Initial ideation — 38 candidates generated across 4 frames
  (developer pain, inversion/automation, assumption-breaking, leverage/compounding),
  23 rejected, 7 survived
