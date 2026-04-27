---
title: "feat: Introduce DemoCRMAdapter and CRMClient for countries lookup"
type: feat
status: completed
date: 2026-04-27
origin: docs/brainstorms/2026-04-24-crm-adapter-architecture-requirements.md
---

# feat: Introduce DemoCRMAdapter and CRMClient for countries lookup

## Overview

The countries endpoint currently returns hardcoded data inline in the controller. This plan extracts that data into the first two layers of the CRM Adapter architecture: a `CRMClient::Countries` delegation class that owns the contract, and a `DemoCRMAdapter::Countries` class that holds the hardcoded values. The controller delegates to `CRMClient::Countries`, which injects `DemoCRMAdapter::Countries` as its default adapter. The Dynamics365Adapter and Dynamics365Client layers are out of scope — this plan establishes the seam so they can be dropped in later without touching the controller.

## Problem Frame

The controller carries inline hardcoded country data, an inline `Country` struct, and no testable seam between the controller and the data source. Before Dynamics365 is available, we need a clean adapter boundary so:
- The CRM contract is explicit and owned by `CRMClient`
- The hardcoded data has a home that is independent of the controller
- The seam between `CRMClient` and any future `Dynamics365Adapter` is established
- All three layers can be unit-tested independently (see origin: `docs/brainstorms/2026-04-24-crm-adapter-architecture-requirements.md`)

## Requirements Trace

- R1. `CRMClient` defines the `Country` value object via `Data.define` — the canonical shape for the countries contract
- R2. `CRMClient::Countries` is a thin delegation class; the controller programs against `CRMClient` only
- R3. The adapter is injected into `CRMClient::Countries` with `DemoCRMAdapter::Countries.new` as the default
- R10. Unit tests for any adapter inject a dependency double and assert correct return types
- R11. Unit tests for `CRMClient::Countries` inject an adapter double and assert delegation behaviour
- R14–R16. File layout follows the prescribed `lib/crm_client/` and `lib/demo_crm_adapter/` paths

## Scope Boundaries

- No `Dynamics365Adapter::Countries` or `Dynamics365Client` — these are the next phase
- No Faraday dependency or VCR cassettes in this plan
- No error taxonomy (`CRM::NotFoundError` etc.) — out of scope per origin document
- No environment-switching or adapter registry — `DemoCRMAdapter::Countries` is the default until the constructor is overridden
- Caching stays entirely in the controller layer via the existing `Cacheable` concern; `CRMClient` is unaware of caching

## Context & Research

### Relevant Code and Patterns

- Hardcoded data and inline struct to extract: `app/controllers/api/lookup_items/countries_controller.rb`
- Caching concern (untouched by this plan): `app/controllers/concerns/cacheable.rb`
- API base controller (untouched): `app/controllers/api/application_controller.rb`
- Existing request spec (should remain green without modification): `spec/requests/api/lookup_items/countries_spec.rb`
- Zeitwerk acronym inflections already registered (`"CRM"`, `"API"`): `config/initializers/inflections.rb`
- Architecture code sketches that show the intended shape (directional only): origin document §Code Sketches

### Institutional Learnings

- No prior `docs/solutions/` entries — this is the first CRM adapter work in this repo

### Architecture decisions from the origin document

- `CRMClient` owns all type definitions; adapters transform into those types, not define them
- Constructor injection throughout; no environment flags or adapter registries
- `lib/` is Zeitwerk-autoloaded; `CRMClient` and `DemoCRMAdapter` acronym resolution already works

## Key Technical Decisions

- **Separate files for value object and delegation class**: `CRMClient::Country` (value object, `lib/crm_client/country.rb`) and `CRMClient::Countries` (delegation class, `lib/crm_client/countries.rb`) are distinct files. R16 requires value objects in their own file; using plural for the delegation class avoids a constant name collision within the same namespace.
- **`DemoCRMAdapter::Countries` not `DemoCRMAdapter::Country`**: Adapter class names mirror their `CRMClient` counterparts (R4). Since the delegation class is `CRMClient::Countries`, the adapter is `DemoCRMAdapter::Countries`.
- **Method name `all`**: The delegation class exposes `#all` (returning `Array<CRMClient::Country>`). This is the simplest contract for a full-collection lookup with no filtering, and it matches the controller's intent (render all countries).
- **`DemoCRMAdapter::Countries` is the default adapter**: Because Dynamics365 is not yet available, the default keyword argument in `CRMClient::Countries#initialize` points to `DemoCRMAdapter::Countries.new`. Swapping in `Dynamics365Adapter::Countries.new` later requires changing one line.
- **No namespace module files required**: Zeitwerk auto-creates namespaces for directories under `lib/`. Neither `lib/crm_client.rb` nor `lib/demo_crm_adapter.rb` needs to be created.

## Open Questions

### Resolved During Planning

- **Zeitwerk acronym resolution for `DemoCRMAdapter`**: The `"CRM"` acronym is already registered in `config/initializers/inflections.rb`. Zeitwerk correctly resolves `DemoCRMAdapter` → `lib/demo_crm_adapter/`. No further inflection setup needed.
- **Value object vs delegation class name collision**: Resolved by using `Country` (singular) for the `Data.define` struct and `Countries` (plural) for the delegation class.
- **Where does caching live?**: Stays in the controller's `Rails.cache.fetch` block; `CRMClient::Countries#all` is cache-unaware and always makes a fresh call to the adapter.

### Deferred to Implementation

- **Dynamics365Adapter field mapping**: OData-style field names from the Dynamics 365 API are not known yet. Deferred to the Dynamics365Adapter plan.
- **Authentication for Dynamics365Client**: OAuth2 or API key setup deferred to the Dynamics365Adapter plan.
- **VCR cassette configuration**: Deferred until the HTTP layer exists.

## High-Level Technical Design

> *This illustrates the intended approach and is directional guidance for review, not implementation specification. The implementing agent should treat it as context, not code to reproduce.*

```
GET /api/lookup_items/countries
        │
        ▼  app/controllers/api/lookup_items/countries_controller.rb
CountriesController#index
  Rails.cache.fetch { CRMClient::Countries.new.all }
  render json: { data: [...] }
        │
        ▼  lib/crm_client/countries.rb
CRMClient::Countries#all
  @adapter.all
        │
        ▼  lib/demo_crm_adapter/countries.rb  (default adapter)
DemoCRMAdapter::Countries#all
  → Array<CRMClient::Country>  (hardcoded, same 5 entries currently in the controller)
```

## Implementation Units

- [ ] **Unit 1: Define `CRMClient::Country` value object**

**Goal:** Create the canonical value object type for countries in the `CRMClient` namespace.

**Requirements:** R1, R16

**Dependencies:** None

**Files:**
- Create: `lib/crm_client/country.rb`
- Test: `spec/lib/crm_client/country_spec.rb`

**Approach:**
- Define `CRMClient::Country = Data.define(:id, :value, :iso_code)` — mirroring the three fields used in the existing controller inline struct and the request spec assertions
- No methods beyond what `Data.define` provides

**Patterns to follow:**
- Inline struct in `app/controllers/api/lookup_items/countries_controller.rb` (the shape to replicate)
- `Data.define` usage confirmed in the architecture origin document

**Test scenarios:**
- Happy path: instantiating `CRMClient::Country` with `id:`, `value:`, and `iso_code:` keyword arguments returns a frozen value object with matching attribute readers
- Edge case: instantiating without all three required fields raises `ArgumentError`
- Edge case: two instances with identical field values are equal (`==` returns `true`) — standard `Data` behaviour worth asserting as a contract

**Verification:**
- `rails zeitwerk:check` passes with the new file present
- Spec passes; the constant is accessible as `CRMClient::Country` from anywhere in the app

---

- [ ] **Unit 2: Create `DemoCRMAdapter::Countries` with hardcoded data**

**Goal:** Move the five hardcoded country objects from the controller into a dedicated adapter class, implementing the `#all` interface.

**Requirements:** R4 (transformation layer responsibility), R16 (file layout)

**Dependencies:** Unit 1 (`CRMClient::Country` must exist)

**Files:**
- Create: `lib/demo_crm_adapter/countries.rb`
- Test: `spec/lib/demo_crm_adapter/countries_spec.rb`

**Approach:**
- Define `DemoCRMAdapter::Countries` with a single public method `#all` that returns the five country records verbatim from the controller, but now as `CRMClient::Country` instances rather than `API::LookupItems::CountriesController::Country` instances
- No constructor arguments needed — there is no injected dependency at this layer
- The five countries and their ISO codes come directly from the existing controller; do not add or remove entries

**Patterns to follow:**
- Hardcoded data shape in `app/controllers/api/lookup_items/countries_controller.rb` (direct source)

**Test scenarios:**
- Happy path: `DemoCRMAdapter::Countries.new.all` returns an `Array` of length 5
- Happy path: every element is an instance of `CRMClient::Country`
- Happy path: the array includes entries matching the expected ISO codes (`"US"`, `"CA"`, `"GB"`, `"AU"`, `"DE"`)
- Happy path: each element responds to `id`, `value`, and `iso_code` readers

**Verification:**
- Spec passes without any Rails.cache setup or request context
- `rails zeitwerk:check` still passes

---

- [ ] **Unit 3: Create `CRMClient::Countries` delegation class**

**Goal:** Establish the thin delegation class that the controller will program against, injecting `DemoCRMAdapter::Countries` as the default adapter.

**Requirements:** R2, R3, R11

**Dependencies:** Units 1 and 2

**Files:**
- Create: `lib/crm_client/countries.rb`
- Test: `spec/lib/crm_client/countries_spec.rb`

**Approach:**
- Define `CRMClient::Countries` with `#initialize(adapter: DemoCRMAdapter::Countries.new)` and a single public `#all` method that calls `@adapter.all` and returns the result
- No transformation logic lives here — the adapter owns that
- The default adapter is `DemoCRMAdapter::Countries.new`; this default changes (to `Dynamics365Adapter::Countries.new`) when the real adapter is built

**Patterns to follow:**
- Architecture sketch in origin document §CRMClient (directional guidance)

**Test scenarios:**
- Happy path: `CRMClient::Countries.new.all` (using the real default adapter) returns an `Array<CRMClient::Country>` with 5 entries — a thin integration smoke test
- Unit: injecting an `instance_double` of `DemoCRMAdapter::Countries` that returns a controlled array; asserts `CRMClient::Countries#all` returns that exact array
- Unit: the injected adapter double's `#all` method is called exactly once per `CRMClient::Countries#all` call

**Verification:**
- Spec passes; `instance_double(DemoCRMAdapter::Countries)` is used for the unit test (exercising RSpec's `verify_partial_doubles` signature checking)

---

- [ ] **Unit 4: Update `CountriesController` to delegate to `CRMClient::Countries`**

**Goal:** Remove the inline `Country` struct and hardcoded data from the controller; replace with a `CRMClient::Countries.new.all` call inside the existing cache block.

**Requirements:** R2 (controllers program against `CRMClient` only)

**Dependencies:** Units 1, 2, and 3

**Files:**
- Modify: `app/controllers/api/lookup_items/countries_controller.rb`
- Test: `spec/requests/api/lookup_items/countries_spec.rb` (no changes expected — existing scenarios must remain green)

**Approach:**
- Remove the `Country = Data.define(...)` constant from the controller
- Replace the hardcoded array inside `Rails.cache.fetch` with `CRMClient::Countries.new.all`
- The `Cacheable` concern and `render json: { data: data }` are untouched
- No new controller behaviour is introduced; the JSON contract is unchanged

**Patterns to follow:**
- `app/controllers/concerns/cacheable.rb` — how `cache_options` is consumed (already established pattern)
- `spec/requests/api/lookup_items/countries_spec.rb` — the existing spec is the acceptance contract; all assertions must pass unmodified

**Test scenarios:**
- Integration: existing request spec (`GET /api/lookup_items/countries`) still returns HTTP 200 with a `data` envelope containing an array of 5 countries, each with `id`, `value`, and `iso_code` fields
- Integration: response content-type is `application/json`
- Integration: the `API::LookupItems::CountriesController::Country` constant is no longer defined (the inline struct is removed)

**Verification:**
- `spec/requests/api/lookup_items/countries_spec.rb` passes with zero modifications
- `bin/ci` (RSpec + RuboCop + brakeman + bundler-audit) passes clean

## System-Wide Impact

- **Interaction graph:** `CountriesController#index` → `CRMClient::Countries#all` → `DemoCRMAdapter::Countries#all`. The `Cacheable` concern continues to wrap the adapter call in `Rails.cache.fetch`; no other controllers or concerns are affected.
- **Error propagation:** `DemoCRMAdapter::Countries#all` has no failure modes (hardcoded data). Error handling across the adapter boundary is deferred to the Dynamics365Adapter plan.
- **State lifecycle risks:** None introduced. The cache key (`request.path` = `/api/lookup_items/countries`) and TTL (2 hours) are unchanged.
- **API surface parity:** No other controllers reference `API::LookupItems::CountriesController::Country`. After the inline struct is removed, the canonical type is `CRMClient::Country`.
- **Integration coverage:** The existing request spec provides end-to-end coverage of the full call chain through the adapter to the controller response. No new request spec scenarios are needed.
- **Unchanged invariants:** The JSON response shape (`{ "data": [...] }` with `id`, `value`, `iso_code` per entry) does not change. The `Cacheable` concern is not modified. The route (`GET /api/lookup_items/countries`) is not modified.

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| Zeitwerk fails to resolve `DemoCRMAdapter` if `"CRM"` acronym is not applied | Confirmed resolved: `inflect.acronym "CRM"` already in `config/initializers/inflections.rb`. Run `rails zeitwerk:check` after adding files. |
| `API::LookupItems::CountriesController::Country` constant referenced elsewhere | Research found no references outside the controller. Verify with a grep during implementation. |
| `verify_partial_doubles = true` in RSpec causes `instance_double(DemoCRMAdapter::Countries)` to fail if the `#all` method does not exist | Resolved by sequencing: the adapter spec (Unit 2) must pass before the CRMClient spec (Unit 3) is written. |
| The `DemoCRMAdapter` default lingers when Dynamics365Adapter is ready | Acceptable: changing the default keyword argument in `CRMClient::Countries#initialize` is a one-line change. No registry or flag needed. |

## Sources & References

- **Origin document:** [docs/brainstorms/2026-04-24-crm-adapter-architecture-requirements.md](docs/brainstorms/2026-04-24-crm-adapter-architecture-requirements.md)
- Related code: `app/controllers/api/lookup_items/countries_controller.rb`
- Related code: `spec/requests/api/lookup_items/countries_spec.rb`
- Related code: `config/initializers/inflections.rb`
