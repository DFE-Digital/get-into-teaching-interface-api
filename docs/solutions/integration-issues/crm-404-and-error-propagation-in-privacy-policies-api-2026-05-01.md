---
title: CRM 404 and Error Propagation in the Privacy Policies API
date: "2026-05-01"
category: integration-issues
module: api/privacy_policies
problem_type: integration_issue
component: rails_controller
severity: high
symptoms:
  - "Unknown privacy policy IDs caused an unhandled exception and a 500 response instead of 404"
  - "All non-404 CRM errors (400, 401, 403, 422, 500, 503) returned HTML bodies from the Rails exceptions_app, breaking JSON API clients"
  - "The /latest endpoint's rescue_from handler produced { resource: 'latest', id: null } instead of { resource: 'privacy_policies', id: 'latest' }"
root_cause: missing_validation
resolution_type: code_fix
tags:
  - error-handling
  - rescue-from
  - crm-integration
  - json-api
  - http-404
  - http-503
  - rails-controller
  - privacy-policies
---

# CRM 404 and Error Propagation in the Privacy Policies API

## Problem

When the upstream CRM returned a 404 for an unknown privacy policy ID, the Rails API propagated the exception as an HTML 500 response instead of a structured JSON 404. All other CRM error responses (400, 401, 403, 422, 500, 503) also surfaced as unhandled HTML 500s, breaking JSON API clients entirely. A third, subtler issue existed on the `/api/privacy_policies/latest` singleton route: even after a `rescue_from` handler was added, the error body it produced was malformed because it inferred metadata from `controller_name` and `params[:id]` — both of which are wrong on a singleton route with a namespaced controller.

## Symptoms

- `GET /api/privacy_policies/:id` with an unknown ID → HTTP 500 with an HTML error page instead of a JSON 404
- Any CRM response other than 404 (e.g., 401, 403, 503) → HTTP 500 with an HTML error page instead of a structured JSON error body
- `GET /api/privacy_policies/latest` when the CRM returned a not-found error → JSON 404 body containing `resource: "latest"` and `id: null`, neither of which is meaningful to a client

## What Didn't Work

**`rescue_from` without hook methods.** The first pass added a single `rescue_from NotFoundError` block directly to `API::ApplicationController` and built the error body inline using `controller_name` and `params[:id]`:

```ruby
rescue_from CRM::Adapters::GetIntoTeaching::Resource::NotFoundError do
  render json: {
    error: {
      message: I18n.t("api.errors.not_found", resource: controller_name, id: params[:id])
    }
  }, status: :not_found
end
```

This broke for `/latest` because `controller_name` returned `"latest"` (the unnamespaced leaf name, not `"privacy_policies"`) and `params[:id]` was `nil` (singleton routes carry no `:id` segment). There was no way for the subcontroller to supply correct values without restructuring the handler.

**Rescuing only `NotFoundError`.** The initial revision only rescued `NotFoundError`, leaving every other CRM exception (the base `Error` class covering 400, 401, 403, 422, 500, 503 responses) completely unhandled. Those continued to produce HTML 500s via the Rails `exceptions_app`.

## Solution

The fix spans four files.

### 1. Introduce `NotFoundError` in the adapter

**`lib/crm/adapters/get_into_teaching/resource.rb`**

```ruby
# Before
class Error < StandardError; end

when 404
  raise Error, "No results were found for your request. #{response.body["error"]}"
```

```ruby
# After
class Error < StandardError; end
class NotFoundError < Error; end

when 404
  raise NotFoundError, "No results were found for your request. #{response.body["error"]}"
```

### 2. Add both `rescue_from` handlers with hook methods

**`app/controllers/api/application_controller.rb`**

The base `Error` handler must be declared **first** so that the more-specific `NotFoundError` handler wins (see [Why This Works](#why-this-works) for the ordering mechanic):

```ruby
# Error must be declared first. Rails searches rescue_handlers in reverse declaration order
# (last-declared wins). Since NotFoundError < Error, both handlers match a NotFoundError;
# declaring Error first ensures the NotFoundError handler (declared last) takes priority.
rescue_from CRM::Adapters::GetIntoTeaching::Resource::Error do
  render json: { error: { message: I18n.t("api.errors.service_unavailable") } },
         status: :service_unavailable
end

rescue_from CRM::Adapters::GetIntoTeaching::Resource::NotFoundError do
  resource_name = not_found_resource_name
  render json: {
    error: {
      message: I18n.t("api.errors.not_found", resource: resource_name.singularize.humanize.downcase, id: not_found_id),
      resource: resource_name,
      id: not_found_id,
    },
  }, status: :not_found
end

private

def not_found_resource_name
  controller_name
end

def not_found_id
  params[:id]
end
```

### 3. Override the hook methods in the singleton subcontroller

**`app/controllers/api/privacy_policies/latest_controller.rb`**

```ruby
def not_found_resource_name = "privacy_policies"
def not_found_id = "latest"
```

### 4. Add translation keys

**`config/locales/en.yml`**

```yaml
api:
  errors:
    not_found: "We could not find a %{resource} with a matching id of `%{id}`. Please check the ID and try again."
    service_unavailable: "The upstream service is currently unavailable. Please try again later."
```

## Why This Works

**`NotFoundError < Error` gives `rescue_from` a target.** The adapter previously raised the same generic `Error` for every failure code. By subclassing, the 404 case becomes independently rescuable without disturbing handling for other status codes.

**`rescue_from` uses last-declared-wins ordering.** Rails stores rescue handlers in an array appended in declaration order, then searches it with `reverse_each` — the last-declared handler matching the exception class is the one that runs. Because `NotFoundError < Error`, both handlers match a `NotFoundError`. Declaring `Error` first and `NotFoundError` second means the `NotFoundError` handler is encountered first during the reverse walk and wins. Reversing the order would cause the `Error` handler (now last-declared, first-found) to intercept every `NotFoundError`, returning 503 instead of 404 — silently swallowing the specific case.

**Hook methods decouple the handler from route topology.** `controller_name` is an implementation detail of how Rails names controllers, not a reliable proxy for the resource name a client cares about. `params[:id]` is absent on singleton routes entirely. By introducing `not_found_resource_name` and `not_found_id` as overridable private methods, the base handler expresses intent ("give me the resource name and the ID that was looked up") while each controller that deviates from the convention can supply correct values locally.

## Prevention

**Establish an error hierarchy in the adapter from the start.** Any adapter wrapping an HTTP backend should define at minimum a base error and a not-found subclass immediately. Reaching for the generic base class for every status code makes differentiated rescue impossible without a later refactor.

```ruby
class Error < StandardError; end
class NotFoundError < Error; end   # add further subclasses as needed
```

**Always pair a specific `rescue_from` with a base-class `rescue_from`.** Adding `rescue_from SpecificError` without also rescuing its superclass leaves all other instances of the superclass unhandled. Treat it as a required pair:

```ruby
rescue_from BaseError do ... end          # declared first
rescue_from SpecificError do ... end      # declared second — wins via last-match
```

**Use hook methods for any handler value that varies by controller.** Whenever a shared `rescue_from` handler needs to reference something about the current resource (name, ID, route structure), encode it as an overridable method rather than reading Rails internals directly. This makes subcontrollers responsible for their own deviations and keeps the shared handler stable:

```ruby
# base controller
def not_found_resource_name = controller_name
def not_found_id = params[:id]

# singleton subcontroller override
def not_found_resource_name = "privacy_policies"
def not_found_id = "latest"
```

**Test both the standard and singleton cases explicitly.** The test suite now covers:

- `spec/lib/crm/adapters/get_into_teaching/resource_spec.rb` — asserts that a 404 CRM response raises `NotFoundError` specifically (not the base `Error`), and verifies the exception message
- `spec/lib/crm/adapters/get_into_teaching/resources/privacy_policies_resource_spec.rb` — 404 context using `stub_request` against the live resource class
- `spec/requests/api/privacy_policies_spec.rb` — six examples covering the not-found response shape and three covering the service-unavailable shape
- `spec/requests/api/privacy_policies/latest_spec.rb` — five examples asserting that the not-found body contains `resource: "privacy_policies"` and `id: "latest"`, not the raw controller name and nil

When adding future singleton-style routes, add a parallel request spec that asserts `resource` and `id` values in the error body — this is the fastest way to catch a missing hook override.

## Related Issues

- See `docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md` for the foundational CRM adapter pattern that defines `Resource::Error` — this solution extends that error class hierarchy up into the controller layer.
