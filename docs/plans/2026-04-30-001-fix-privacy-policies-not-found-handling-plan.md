---
title: "fix: Handle not-found IDs in api/privacy_policies"
type: fix
status: active
date: 2026-04-30
---

# fix: Handle not-found IDs in api/privacy_policies

## Overview

`GET /api/privacy_policies/:id` currently returns a 500 Internal Server Error when
the upstream CRM responds with a 404 for an unknown ID. This plan adds a dedicated
`NotFoundError` subclass to the GetIntoTeaching adapter and a `rescue_from` handler
in `API::ApplicationController` so that all show-style endpoints return a structured
JSON 404 response containing a human-readable message and machine-readable fields
(resource name and ID) to help consumers understand and recover from the error.

## Problem Frame

The CRM adapter already raises `CRM::Adapters::GetIntoTeaching::Resource::Error` for
every non-2xx status (400, 401, 403, 404, 422, 500, 503), but nothing in the
controller stack catches it. A CRM 404 therefore propagates as an unhandled exception
and surfaces as a 500. The fix must:

1. Make the 404 case distinguishable from other CRM errors at the rescue site.
2. Rescue it centrally so all current and future `show` actions inherit the behaviour.
3. Return a structured JSON body with status 404 containing:
   - a human-readable `message` using the route resource name and the requested ID
   - machine-readable `resource` (the route resource name, e.g. `"privacy_policies"`) and `id` fields

## Requirements Trace

- R1. `GET /api/privacy_policies/:id` with an unknown ID returns HTTP 404 and a structured JSON error body.
- R2. The 404 response is JSON regardless of the `Accept` header sent by the client.
- R3. Other CRM errors (401, 403, 500, …) are not accidentally swallowed or mis-mapped.
- R4. The Demo adapter continues to satisfy all existing request-spec examples unchanged.
- R5. The error body contains a human-readable `message` and machine-readable `resource` and `id` fields derived from the request, not from the CRM error string or from controller/class names.

## Scope Boundaries

- Only 404 (not-found) handling is addressed; handling other CRM errors (e.g. mapping
  503 → 502) is out of scope and left as future work.
- The Demo adapter stub is not changed; request-spec not-found coverage uses an
  `instance_double` to raise the error without touching the Demo adapter.
- No changes to routing or the `ErrorsController` (which renders HTML and is
  intentionally outside the API namespace).

## Context & Research

### Relevant Code and Patterns

- `lib/crm/adapters/get_into_teaching/resource.rb` — `handle_response` raises the flat
  `Resource::Error` for all non-2xx statuses including 404.
- `app/controllers/api/application_controller.rb` — currently contains only
  `include Cacheable`; no `rescue_from` present.
- `app/controllers/api/privacy_policies_controller.rb` — calls
  `crm_client.privacy_policies.find(params[:id])` inside `Rails.cache.fetch`.
- `spec/lib/crm/adapters/get_into_teaching/resource_spec.rb` — hash-driven loop tests
  that every mapped status raises `Resource::Error`; the 404 entry will need a
  companion assertion for `NotFoundError` specifically.
- `spec/lib/crm/adapters/get_into_teaching/resources/privacy_policies_resource_spec.rb`
  — currently tests 200 (happy path) and 401 (generic error); needs a 404 stub_request
  scenario.
- `spec/requests/api/privacy_policies_spec.rb` — no 404 test scenarios exist today.

### Institutional Learnings

- Error-path tests must use `stub_request` directly, not VCR cassettes (established in
  `docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md`).
- Request specs must call `Rails.cache.clear` in a `before` block (already present in
  the privacy_policies spec).
- Use `instance_double` for adapter doubles (`verify_partial_doubles: true` is global).
- Use `response.parsed_body` for JSON body assertions in request specs (Rails 7.1+).

## Key Technical Decisions

- **Introduce `Resource::NotFoundError < Resource::Error`** rather than parsing the
  message string at the rescue site. A dedicated subclass is idiomatic Ruby, keeps the
  rescue clause narrow, and avoids brittle string matching.
- **Rescue in `API::ApplicationController`**, not in individual controllers. All API
  endpoints inherit from it, so the fix applies automatically to future `show` actions
  without repetition.
- **Structured error body with `message`, `resource`, and `id`**. The response shape is:
  ```json
  {
    "error": {
      "message": "We could not find a privacy policy with a matching id of `abc-123`. Please check the ID and try again.",
      "resource": "privacy_policies",
      "id": "abc-123"
    }
  }
  ```
  This is directional guidance — the implementer should treat the structure as the target shape, not copy-paste it literally.
- **Message string via I18n**, not hardcoded in the controller. Define the template in
  `config/locales/en.yml` under `en.api.errors.not_found` with `resource` and `id`
  interpolation variables. The `rescue_from` handler calls `I18n.t` with those values.
  This keeps wording changes out of application code entirely.
- **Resource name from the route, not the controller class**. Derive it from
  `request.path_parameters[:controller]` (e.g. `"api/privacy_policies"`) by splitting
  on `/` and taking the last segment (`"privacy_policies"`). This keeps the machine-readable
  field tied to the public API surface rather than internal naming.
- **Human-readable resource label from the route resource name**. Singularize and
  humanize the route resource name (`"privacy_policies" → "privacy policy"`) for use in
  the `message` string. Rails' `String#singularize` and `String#humanize` cover this
  without extra dependencies.
- **ID from `params[:id]`**. The `rescue_from` handler has access to `params` directly;
  no need to store the ID on the exception object.
- **Message does not echo the CRM error string** to avoid leaking upstream details.
- **Do not change the Demo adapter**. The Demo adapter's `find` returns a stub for any
  ID. Request-spec coverage of the 404 path uses `instance_double(CRM::Client)` to
  inject the error without requiring a sentinel ID in the Demo adapter.
- **The existing hash-driven loop in `resource_spec.rb`** asserts `Resource::Error` for
  the 404 entry and will continue to pass because `NotFoundError` inherits from
  `Resource::Error`. Add a separate example asserting the more specific subclass.

## Open Questions

### Resolved During Planning

- *Should other CRM error codes also be mapped to HTTP statuses?* No — scope is
  limited to not-found. Other codes are future work.
- *Should the Demo adapter raise for a sentinel ID?* No — `instance_double` in request
  specs is sufficient and avoids coupling the Demo adapter to test concerns.
- *Should the rescue be in the individual controller or the base controller?* Base
  controller, for DRY inheritance.

### Deferred to Implementation

- Whether to extract the resource-name derivation and message-building logic into a
  private helper method or concern on `API::ApplicationController` (reasonable if future
  error types follow the same pattern, but premature to abstract now).

## Implementation Units

- [ ] **Unit 1: Introduce `Resource::NotFoundError` and raise it for CRM 404 responses**

  **Goal:** Make the 404 case distinguishable from other CRM errors via a dedicated
  exception subclass.

  **Requirements:** R1, R3

  **Dependencies:** None

  **Files:**
  - Modify: `lib/crm/adapters/get_into_teaching/resource.rb`
  - Modify: `spec/lib/crm/adapters/get_into_teaching/resource_spec.rb`

  **Approach:**
  - Declare `class NotFoundError < Error; end` inside `Resource`.
  - In `handle_response`, change the `when 404` branch to raise `NotFoundError`
    instead of `Error`.
  - All other branches continue raising `Error` unchanged.

  **Patterns to follow:**
  - `lib/crm/adapters/get_into_teaching/resource.rb` — existing `Error` class and
    `handle_response` switch.

  **Test scenarios:**
  - Happy path: `handle_response` with status 200 still returns the response object.
  - Happy path: `handle_response` with status 404 raises `Resource::NotFoundError`.
  - Happy path: `NotFoundError` is also a `Resource::Error` (is-a assertion).
  - Edge case: `handle_response` with status 401, 403, 500, 503 raises `Resource::Error`
    but NOT `Resource::NotFoundError`.
  - (The existing hash-driven loop covers the `Resource::Error` assertion for 404 — add
    one new example specifically asserting `NotFoundError` for 404.)

  **Verification:**
  - All existing `resource_spec.rb` examples continue to pass.
  - New example asserting `NotFoundError` for 404 passes.

---

- [ ] **Unit 2: Add 404 coverage to the GetIntoTeaching privacy policies resource spec**

  **Goal:** Confirm that `PrivacyPoliciesResource#find` propagates a `NotFoundError`
  when the upstream CRM returns 404.

  **Requirements:** R1, R3

  **Dependencies:** Unit 1

  **Files:**
  - Modify: `spec/lib/crm/adapters/get_into_teaching/resources/privacy_policies_resource_spec.rb`

  **Approach:**
  - Add a new context within the `#find` describe block that stubs the request to
    return `status: 404` with a JSON error body.
  - Assert `raise_error(CRM::Adapters::GetIntoTeaching::Resource::NotFoundError)`.
  - Follow the existing 401 context in the same file as the pattern (uses `stub_request`
    with a `before` block that overrides the outer stub).

  **Patterns to follow:**
  - Existing `"when the API returns an error"` context in
    `spec/lib/crm/adapters/get_into_teaching/resources/privacy_policies_resource_spec.rb`.

  **Test scenarios:**
  - Error path: `find("some-id")` with a stubbed 404 response raises `NotFoundError`.

  **Verification:**
  - New example passes; no existing examples regress.

---

- [ ] **Unit 3: Rescue `NotFoundError` in `API::ApplicationController` and cover it in the request spec**

  **Goal:** Translate a CRM `NotFoundError` into a structured JSON 404 response for all
  API endpoints; verify end-to-end via the privacy policies request spec.

  **Requirements:** R1, R2, R3, R4, R5

  **Dependencies:** Unit 1

  **Files:**
  - Modify: `app/controllers/api/application_controller.rb`
  - Modify: `config/locales/en.yml`
  - Modify: `spec/requests/api/privacy_policies_spec.rb`

  **Approach:**
  - Define the message template in `config/locales/en.yml`:
    ```yaml
    en:
      api:
        errors:
          not_found: "We could not find a %{resource} with a matching id of `%{id}`. Please check the ID and try again."
    ```
    This is directional — the implementer places it under the correct existing key
    structure in the file.
  - Add `rescue_from CRM::Adapters::GetIntoTeaching::Resource::NotFoundError` to
    `API::ApplicationController`. Inside the handler:
    - Derive `resource_name` from `request.path_parameters[:controller]` — split on `/`
      and take the last segment (e.g. `"privacy_policies"`).
    - Derive `human_resource` by singularizing then humanizing and downcasing
      `resource_name` (e.g. `"privacy policy"`).
    - Look up the message via `I18n.t("api.errors.not_found", resource: human_resource, id: params[:id])`.
    - Render `{ error: { message:, resource: resource_name, id: params[:id] } }` with
      `status: :not_found`.
  - In the request spec, add a `describe "when the id is not found"` block. Use
    `instance_double(CRM::Client)` stubbed to raise `NotFoundError` when
    `privacy_policies.find(…)` is called. Inject the double by stubbing
    `CRM::Client.new` to return it.
  - The `Rails.cache.clear` `before` block is already in place.

  **Patterns to follow:**
  - `instance_double` usage in `spec/lib/crm/adapters/get_into_teaching/resource_spec.rb`.
  - Existing describe blocks in `spec/requests/api/privacy_policies_spec.rb` for
    request-spec structure.

  **Test scenarios:**
  - Error path: `GET /api/privacy_policies/unknown-id` (CRM double raises `NotFoundError`)
    → response status is 404.
  - Error path: same request → `Content-Type` is `application/json`.
  - Error path: same request → `response.parsed_body.dig("error", "message")` equals
    `I18n.t("api.errors.not_found", resource: "privacy policy", id: "unknown-id")`
    (assert against the translation lookup, not a hardcoded string, so rewording the
    locale file doesn't break specs).
  - Error path: same request → `response.parsed_body.dig("error", "resource")` equals
    `"privacy_policies"` (the route name, not the controller class).
  - Error path: same request → `response.parsed_body.dig("error", "id")` equals the
    ID passed in the URL.
  - Error path: `GET /api/privacy_policies/unknown-id` with `Accept: text/html` →
    response is still JSON (R2).
  - Integration: `GET /api/privacy_policies/example-id` (existing happy-path stub) still
    returns 200 with a `data` envelope (regression guard).

  **Verification:**
  - All scenarios above pass.
  - No existing request-spec examples regress.
  - Running `bin/ci` passes cleanly.

## System-Wide Impact

- **Interaction graph:** `rescue_from` in `API::ApplicationController` will apply to
  every current and future controller that inherits from it. Only `NotFoundError` is
  caught — other `Resource::Error` subclasses pass through unaffected.
- **Error propagation:** `NotFoundError` is raised inside `Rails.cache.fetch`; Rails
  does not cache exceptions, so uncached behaviour is preserved. The rescue handler
  fires before any render, so no double-render risk.
- **Unchanged invariants:** The `ErrorsController` and its HTML 404 page are untouched.
  The Demo adapter's `find` continues to return stubs for all IDs. Existing `index`
  endpoints that return collections are unaffected — they never call `find`.
- **API surface parity:** No other `show` endpoints exist today beyond
  `privacy_policies`. When future `show` actions are added they will automatically
  inherit the rescue behaviour from `API::ApplicationController`.

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| `rescue_from` accidentally swallows non-404 CRM errors | Rescue only the specific `NotFoundError` subclass, not the parent `Resource::Error` |
| Cache layer interacts unexpectedly with raised exceptions | Rails does not cache exceptions from `cache.fetch` blocks; existing `Rails.cache.clear` in specs prevents cross-test contamination |
| Future adapters that don't raise `NotFoundError` silently return 200 for unknown IDs | The abstract base `CRM::Resources::PrivacyPoliciesResource#find` raises `NotImplementedError` — missing implementations surface immediately |

## Sources & References

- Related code: `lib/crm/adapters/get_into_teaching/resource.rb`
- Related code: `app/controllers/api/application_controller.rb`
- Related code: `spec/requests/api/privacy_policies_spec.rb`
- Adapter pattern reference: `docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md`
