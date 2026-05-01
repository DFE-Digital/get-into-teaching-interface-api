---
title: CRM Adapter Pattern — LookUpItems Architecture
date: "2026-04-27"
last_updated: "2026-04-29"
category: docs/solutions/best-practices
module: CRM Adapter
problem_type: best_practice
component: service_object
severity: medium
applies_when:
  - Building a Rails JSON API gateway that proxies an external CRM HTTP API
  - A controller returns hardcoded data with no abstraction layer or testable seam
  - Multiple adapter implementations are anticipated and swappability is required
  - A new lookup resource is added to the same family (subjects, phases, etc.)
  - Migrating an existing external API into this codebase as a CRM adapter
tags:
  - crm
  - adapter-pattern
  - constructor-injection
  - zeitwerk
  - data-define
  - demo-adapter
  - get-into-teaching-api
  - faraday
  - vcr
  - webmock
  - dotenv
  - lookup-items
  - architecture
---

# CRM Adapter Pattern — LookUpItems Architecture

## Context

The `get-into-teaching-interface-api` is a Rails 8 JSON API gateway that proxies requests to an upstream CRM (the Get Into Teaching API). The application needs to serve lookup data — reference lists such as countries, subjects, and phases — that the upstream CRM exposes.

Before this pattern was established there was no defined structure for how controllers, CRM client code, and HTTP adapter logic should be organised. Without a clear pattern, each developer adding a new lookup resource would make independent structural decisions, leading to inconsistent namespaces, ad-hoc HTTP logic scattered through the codebase, and no testable seam between the controller layer and the upstream HTTP dependency.

The immediate trigger was implementing `GET /api/lookup_items/countries`. Solving it systematically produced a reusable architecture that every subsequent lookup endpoint must follow.

## Guidance

### The three-level call chain

Every lookup endpoint follows the same delegation path:

```
Controller
  → CRM::Client#lookup_items            (facade, injects adapter)
    → LookUpItemsResource#countries     (adapter-specific grouping object)
      → CountriesResource#all           (adapter-specific HTTP or stub resource)
        → Array<CountryResource>        (plain array — controller wraps in { data: })
```

The controller reads as a single fluent call:

```ruby
# app/controllers/api/lookup_items/countries_controller.rb
class API::LookupItems::CountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client.new.lookup_items.countries.all
    end
    render json: { data: data }
  end
end
```

The `LookUpItems` namespace in `lib/crm/` mirrors `API::LookupItems` in the controller namespace. A developer reading the route immediately knows where to find both the controller and the CRM resource.

### CRM::Client — constructor-injected facade

`CRM::Client` accepts an adapter at construction time. The default is the Demo adapter so the app is runnable without credentials. No environment-flag switching happens inside `Client`.

```ruby
# lib/crm/client.rb
module CRM
  class Client
    def initialize(adapter: CRM::Adapters::Demo::Client.new)
      @adapter = adapter
    end

    def lookup_items
      @adapter.lookup_items
    end
  end
end
```

Swap adapters in tests by passing `adapter:` explicitly. Never read `ENV` inside `CRM::Client`.

### Abstract base classes

Define abstract bases in `lib/crm/resources/` — outside any adapter directory. Each method raises `NotImplementedError` to surface missing implementations immediately at runtime.

```ruby
# lib/crm/resources/look_up_items_resource.rb
module CRM
  module Resources
    class LookUpItemsResource
      def countries(*)
        raise NotImplementedError
      end
    end
  end
end

# lib/crm/resources/look_up_items/countries_resource.rb
module CRM
  module Resources
    module LookUpItems
      class CountriesResource
        # @return [Array<CRM::Resources::LookUpItems::CountryResource>]
        def all(*)
          raise NotImplementedError
        end
      end
    end
  end
end
```

### Value objects with Data.define

Represent each CRM entity as an immutable value object at the shared `CRM::Resources::LookUpItems` level — not inside any adapter, and not in the controller namespace. `Data.define` gives structural equality, immutability, and `ArgumentError` on missing fields for free.

```ruby
# lib/crm/resources/look_up_items/country_resource.rb
module CRM
  module Resources
    module LookUpItems
      CountryResource = Data.define(:id, :value, :iso_code)
    end
  end
end
```

### The HTTP base class

All HTTP-backed resources inherit from `CRM::Adapters::GetIntoTeaching::Resource`. It provides request helpers, centralised error handling, and key transformation. `response_to_collection` returns a **plain Ruby array** — the controller is responsible for wrapping in `{ data: }`.

```ruby
# lib/crm/adapters/get_into_teaching/resource.rb  (key interface)
class Resource
  class Error < StandardError; end

  # Returns a plain Array<type> — not { data: [...] }
  def response_to_collection(response, type:)
    body = response.body || []
    body.map { |attrs| type.new(**underscore_and_sym_keys(attrs)) }
  end

  # Raises Resource::NotFoundError (< Resource::Error) for 404; Resource::Error for all other failures.
  # Returns response on 200. See docs/solutions/integration-issues/crm-404-and-error-propagation-in-privacy-policies-api-2026-05-01.md
  # for how API::ApplicationController rescues these and renders structured JSON error responses.
  def handle_response(response) = ...

  private

  # "isoCode" → :iso_code
  def underscore_and_sym_keys(attrs)
    attrs.transform_keys(&:underscore).transform_keys(&:to_sym)
  end
end
```

A concrete HTTP countries resource:

```ruby
# lib/crm/adapters/get_into_teaching/resources/look_up_items/countries_resource.rb
module CRM::Adapters::GetIntoTeaching::Resources::LookUpItems
  class CountriesResource < CRM::Adapters::GetIntoTeaching::Resource
    def all(**params)
      response = get_request("/api/lookup_items/countries", params: params)
      response_to_collection(response, type: CRM::Resources::LookUpItems::CountryResource)
    end
  end
end
```

### The LookUpItemsResource intermediary

The `LookUpItemsResource` sits between the adapter client and the individual resource classes. It inherits from the abstract base (`CRM::Resources::LookUpItemsResource`), not from `CRM::Adapters::GetIntoTeaching::Resource`, because it makes no HTTP calls — it constructs resource objects and passes the client through.

```ruby
# lib/crm/adapters/get_into_teaching/resources/look_up_items_resource.rb
module CRM::Adapters::GetIntoTeaching::Resources
  class LookUpItemsResource < CRM::Resources::LookUpItemsResource
    def initialize(client)
      @client = client
    end

    def countries
      LookUpItems::CountriesResource.new(@client)
    end
  end
end
```

### The HTTP adapter client

```ruby
# lib/crm/adapters/get_into_teaching/client.rb
module CRM::Adapters::GetIntoTeaching
  class Client
    attr_reader :base_url, :api_key

    def initialize(base_url: ENV["GET_INTO_TEACHING_BASE_URL"],
                   api_key:  ENV["GET_INTO_TEACHING_API_KEY"])
      @base_url = base_url
      @api_key  = api_key
    end

    def lookup_items
      Resources::LookUpItemsResource.new(self)
    end

    def connection
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request :authorization, :Bearer, api_key
        conn.request :json
        conn.response :json, content_type: "application/json"
      end
    end
  end
end
```

### Environment variables

Use `dotenv-rails`. Commit `.env.template` with placeholder values to document required variables. Add `.env.local` to `.gitignore`. Never read `.env.local` directly in code.

```
# .env.template
GET_INTO_TEACHING_BASE_URL=GET_INTO_TEACHING_BASE_URL
GET_INTO_TEACHING_API_KEY=GET_INTO_TEACHING_API_KEY
```

### Zeitwerk acronym registration

Any directory whose name is an acronym must be registered in `config/initializers/inflections.rb`. Failing to do this causes Zeitwerk to resolve `crm/` as `Crm` instead of `CRM`, producing a `NameError` at load time.

```ruby
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "CRM"
  inflect.acronym "API"
end
```

Verify with `rails zeitwerk:check` after adding any new file or directory under `lib/` or `app/`.

### Testing patterns

**Delegation specs** — use `instance_double` with `verify_partial_doubles: true` (set globally in `spec_helper.rb`) to test that `CRM::Client` delegates correctly:

```ruby
let(:adapter)  { instance_double(CRM::Adapters::Demo::Client) }
let(:resource) { instance_double(CRM::Adapters::Demo::Resources::LookUpItemsResource) }

before { allow(adapter).to receive(:lookup_items).and_return(resource) }

it "delegates #lookup_items to the adapter" do
  expect(CRM::Client.new(adapter: adapter).lookup_items).to eq(resource)
end
```

**Happy-path integration** — use VCR with explicit cassette names to decouple cassette files from example descriptions. If the cassette name is derived from the RSpec description, renaming the example for clarity breaks the recording.

```ruby
describe "#lookup_items.countries",
         vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/countries" } do
  subject(:result) { adapter.lookup_items.countries.all }

  it "returns CountryResource instances" do
    expect(result).to all(be_a(CRM::Resources::LookUpItems::CountryResource))
  end

  it "deserialises the first entry correctly" do
    expect(result.first).to eq(
      CRM::Resources::LookUpItems::CountryResource.new(
        id: "fdf3c2e6-74f9-e811-a97a-000d3a2760f2",
        value: "Afghanistan",
        iso_code: "AF"
      )
    )
  end

  it "handles entries with a null iso_code" do
    unknown = result.find { |c| c.value == "Unknown" }
    expect(unknown.iso_code).to be_nil
  end
end
```

**`require 'webmock/rspec'` must be explicit** in `spec/support/vcr.rb`. VCR's `hook_into :webmock` activates the WebMock adapter internally but does NOT load the `stub_request` DSL into the test context. Without it, `stub_request` raises `NoMethodError`.

**Error-path and attribute-mapping unit tests** — use `stub_request` directly rather than VCR cassettes. This keeps error-path tests free of cassette management.

```ruby
before do
  stub_request(:get, "#{base_url}/api/lookup_items/countries")
    .to_return(status: 401, body: { "error" => "Unauthorized" }.to_json,
               headers: { "Content-Type" => "application/json" })
end

it "raises Resource::Error" do
  expect { resource.all }
    .to raise_error(CRM::Adapters::GetIntoTeaching::Resource::Error,
                    /valid authentication credentials/)
end
```

## Why This Matters

**Swappable adapters without env flags.** Constructor injection means the Demo adapter works in development without credentials, the live adapter works in production, and tests inject a stub. There is no `if Rails.env.test?` or `ENV["CRM_ADAPTER"]` conditional anywhere in the call chain.

**Namespace mirrors route structure.** `API::LookupItems::CountriesController` matches `GET /api/lookup_items/countries`, and `CRM::Resources::LookUpItems::CountryResource` mirrors that same grouping concept. A developer reading the route immediately knows where to find both the controller and the CRM resource.

**Abstract bases surface missing implementations immediately.** Without `NotImplementedError`, a new adapter that forgets to implement `#countries` returns `nil` and produces a confusing `NoMethodError` deep in the call chain. The abstract base surfaces the omission at the point of the call.

**Value objects enforce the contract at the boundary.** `Data.define` means the HTTP adapter cannot return a hash with a missing field silently — `ArgumentError` fires at object construction, not somewhere downstream.

**`response_to_collection` returns a plain array.** Keeping the JSON envelope (`{ data: }`) in the controller means the CRM layer is ignorant of the API response format. If the envelope changes (e.g. adding pagination metadata), only the controller changes.

**Explicit VCR cassette names.** Decoupling cassette file names from RSpec example descriptions means recorded HTTP interactions remain valid when examples are renamed for clarity.

## When to Apply

- Any new `GET /api/lookup_items/:resource` endpoint is being added.
- A new entity type needs to be fetched from the upstream CRM and returned as a JSON collection.
- A new adapter needs to be introduced — the abstract base classes define exactly which methods must be implemented.
- Writing tests for any layer in the CRM call chain: use `instance_double` at the `CRM::Client` level, VCR for happy-path integration, `stub_request` for error paths and attribute mapping.
- A new directory is added under `lib/crm/` or `app/controllers/api/` whose name contains an acronym.

## Examples

### Before — no defined structure

```ruby
# Anti-pattern: ad-hoc HTTP in a controller
class API::LookupItems::CountriesController < ApplicationController
  def index
    response = Faraday.get(
      "#{ENV['CRM_BASE_URL']}/lookup_items/countries",
      {},
      "Authorization" => "Bearer #{ENV['CRM_API_KEY']}"
    )
    render json: JSON.parse(response.body)
  end
end
```

Problems: untestable without network, no value object contract, no adapter abstraction, raw CRM JSON shape exposed to the client.

### After — controller delegates through the full chain

```ruby
class API::LookupItems::CountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client.new.lookup_items.countries.all
    end
    render json: { data: data }
  end
end
```

### Adding a new lookup resource: subjects

> **Use the generator.** As of 2026-04-29, a Rails generator automates all of the steps below:
> ```bash
> rails generate crm_endpoint lookup_items/subjects
> bundle exec rails zeitwerk:check
> ```
> See [`docs/solutions/developer-experience/crm-endpoint-generator-rails-scaffolding-2026-04-29.md`](../developer-experience/crm-endpoint-generator-rails-scaffolding-2026-04-29.md) for full usage details including depth-3 paths, idempotency, and the VCR cassette recording step.
>
> The manual steps below remain useful for understanding the architecture, but should not be followed when adding a new endpoint.

Follow these steps in order. Each step adds exactly one file or one method.

**1.** Value object:

```ruby
# lib/crm/resources/look_up_items/subject_resource.rb
module CRM
  module Resources
    module LookUpItems
      SubjectResource = Data.define(:id, :value)
    end
  end
end
```

**2.** Abstract `SubjectsResource`:

```ruby
# lib/crm/resources/look_up_items/subjects_resource.rb
module CRM
  module Resources
    module LookUpItems
      class SubjectsResource
        def all(*); raise NotImplementedError; end
      end
    end
  end
end
```

**3.** Add `#subjects` to the abstract `LookUpItemsResource`:

```ruby
# lib/crm/resources/look_up_items_resource.rb
def subjects(*)
  raise NotImplementedError
end
```

**4.** Demo adapter stub — add method to `Demo::Resources::LookUpItemsResource`:

```ruby
def subjects
  LookUpItems::SubjectsResource.new
end
```

And the stub resource:

```ruby
# lib/crm/adapters/demo/resources/look_up_items/subjects_resource.rb
module CRM
  module Adapters
    module Demo
      module Resources
        module LookUpItems
          class SubjectsResource < CRM::Resources::LookUpItems::SubjectsResource
            def all
              [
                CRM::Resources::LookUpItems::SubjectResource.new(id: "1", value: "Maths"),
                CRM::Resources::LookUpItems::SubjectResource.new(id: "2", value: "Physics"),
              ]
            end
          end
        end
      end
    end
  end
end
```

**5.** HTTP adapter — add method to `GetIntoTeaching::Resources::LookUpItemsResource`:

```ruby
def subjects
  LookUpItems::SubjectsResource.new(@client)
end
```

And the HTTP resource:

```ruby
# lib/crm/adapters/get_into_teaching/resources/look_up_items/subjects_resource.rb
module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module LookUpItems
          class SubjectsResource < CRM::Adapters::GetIntoTeaching::Resource
            def all(**params)
              response = get_request("/api/lookup_items/subjects", params: params)
              response_to_collection(response, type: CRM::Resources::LookUpItems::SubjectResource)
            end
          end
        end
      end
    end
  end
end
```

**6.** Controller and route (follow existing `countries` controller as the template).

**7.** Run `rails zeitwerk:check`.

### Directory layout

```
lib/crm/
  client.rb                                      # #lookup_items → adapter.lookup_items
  resources/
    look_up_items_resource.rb                    # abstract — #countries raises NotImplementedError
    look_up_items/
      country_resource.rb                        # Data.define value object
      countries_resource.rb                      # abstract — #all raises NotImplementedError
  adapters/
    demo/
      client.rb                                  # #lookup_items → Resources::LookUpItemsResource.new
      resources/
        look_up_items_resource.rb                # #countries → LookUpItems::CountriesResource.new
        look_up_items/
          countries_resource.rb                  # hardcoded 5 entries
    get_into_teaching/
      client.rb                                  # #lookup_items → Resources::LookUpItemsResource.new(self)
      resource.rb                                # HTTP base: handle_response, response_to_collection
      resources/
        look_up_items_resource.rb                # #countries → LookUpItems::CountriesResource.new(@client)
        look_up_items/
          countries_resource.rb                  # GET /api/lookup_items/countries

spec/lib/crm/
  client_spec.rb                                 # delegation with instance_double
  resources/
    look_up_items_resource_spec.rb               # abstract base raises NotImplementedError
    look_up_items/
      country_resource_spec.rb                   # Data.define contract
      countries_resource_spec.rb                 # abstract raises NotImplementedError
  adapters/
    demo/
      client_spec.rb
      resources/
        look_up_items_resource_spec.rb
        look_up_items/
          countries_resource_spec.rb             # 5 entries, ISO codes
    get_into_teaching/
      client_spec.rb                             # VCR cassette, explicit cassette_name
      resource_spec.rb                           # handle_response, response_to_collection
      resources/
        look_up_items_resource_spec.rb
        look_up_items/
          countries_resource_spec.rb             # stub_request, type mapping, error handling

spec/cassettes/
  CRM_Adapters_GetIntoTeaching_Client/
    countries.yml                                # VCR cassette — explicit name
```

## Related

- Architecture requirements: [`docs/brainstorms/2026-04-24-crm-adapter-architecture-requirements.md`](../../brainstorms/2026-04-24-crm-adapter-architecture-requirements.md)
- Design ideation: [`docs/ideation/2026-04-24-crm-adapter-pattern-ideation.md`](../../ideation/2026-04-24-crm-adapter-pattern-ideation.md)
- Original plan: [`docs/plans/2026-04-27-001-feat-demo-crm-adapter-countries-plan.md`](../../plans/2026-04-27-001-feat-demo-crm-adapter-countries-plan.md)
