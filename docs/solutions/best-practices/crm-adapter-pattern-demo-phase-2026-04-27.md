---
title: CRM Adapter Pattern — Demo Phase Before Live Integration
date: "2026-04-27"
category: docs/solutions/best-practices
module: CRM Adapter
problem_type: best_practice
component: service_object
severity: medium
applies_when:
  - Adding an external CRM integration where the real backend is not yet available
  - A controller returns hardcoded data with no abstraction layer or testable seam
  - Multiple adapter implementations are anticipated and swappability is required
  - A new lookup resource is added to the same family (subjects, phases, etc.)
tags:
  - crm
  - adapter-pattern
  - constructor-injection
  - zeitwerk
  - data-define
  - demo-adapter
  - dynamics365
  - architecture
---

# CRM Adapter Pattern — Demo Phase Before Live Integration

## Context

The app's first live endpoint (`GET /api/lookup_items/countries`) was implemented with an
inline `Country` struct and a hardcoded country array directly inside the controller. This
works for a first pass but creates friction when a real CRM backend (Dynamics 365) is
eventually wired in: the controller would need to change, there is no injection point for
swapping data sources, and the value object type has no canonical home outside the
controller's own constant namespace.

The gap was the absence of an adapter layer between the controller and any source of data.
Without it, introducing a real CRM client would require modifying controller logic rather
than swapping a dependency, and there is no interface for specs to verify against
independently.

## Guidance

Introduce a three-layer CRM adapter architecture under `lib/crm/`. Each layer has one
responsibility and one reason to change.

### 1. Value objects — `lib/crm/client/`

Define immutable value objects using `Data.define`. These form the canonical contract: all
adapters return these types, and the controller depends only on these types. The type
definition lives in `CRM::Client`, not in any adapter or controller.

```ruby
# lib/crm/client/country.rb
module CRM
  module Client
    Country = Data.define(:id, :value, :iso_code)
  end
end
```

### 2. Delegation class — `lib/crm/client/countries.rb`

A thin class receives an adapter via constructor injection and exposes a single `#all`
method. The default adapter is the Demo one. Swapping to Dynamics 365 later requires
changing one keyword argument default — nothing else.

```ruby
# lib/crm/client/countries.rb
module CRM
  module Client
    class Countries
      def initialize(adapter: CRM::Adapters::Demo::Countries.new)
        @adapter = adapter
      end

      def all
        @adapter.all
      end
    end
  end
end
```

### 3. Adapter — `lib/crm/adapters/demo/countries.rb`

Each adapter implements `#all` and returns an array of the canonical value object type.
The Demo adapter holds hardcoded data. Future adapters live in parallel directories under
`lib/crm/adapters/` and are dropped in next to the demo one without touching any other
layer.

```ruby
# lib/crm/adapters/demo/countries.rb
module CRM
  module Adapters
    module Demo
      class Countries
        def all
          [
            CRM::Client::Country.new(id: "3fa85f64-...", value: "United States", iso_code: "US"),
            CRM::Client::Country.new(id: "3fa85f64-...", value: "Canada",        iso_code: "CA"),
            # ...
          ]
        end
      end
    end
  end
end
```

### Controller usage

Caching stays in the controller. `CRM::Client` is cache-unaware.

```ruby
# app/controllers/api/lookup_items/countries_controller.rb
class API::LookupItems::CountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client::Countries.new.all
    end
    render json: { data: data }
  end
end
```

### Zeitwerk and the CRM acronym

`inflect.acronym "CRM"` is already registered in `config/initializers/inflections.rb`.
Zeitwerk resolves `CRM` ↔ `lib/crm/` automatically. No additional autoload path
configuration is needed — confirm with `rails zeitwerk:check` after adding new files.

### Specs

Use `instance_double` to verify the adapter interface at the delegation layer. Because
`verify_partial_doubles: true` is set in `spec/rails_helper.rb`, RSpec enforces that the
method being stubbed actually exists on the real class.

```ruby
# spec/lib/crm/client/countries_spec.rb
let(:adapter) { instance_double(CRM::Adapters::Demo::Countries) }
let(:stub_countries) { [ CRM::Client::Country.new(id: "1", value: "France", iso_code: "FR") ] }

before { allow(adapter).to receive(:all).and_return(stub_countries) }

it "delegates #all to the adapter" do
  result = CRM::Client::Countries.new(adapter: adapter).all
  expect(result).to eq(stub_countries)
end
```

Also include a smoke test using the real default adapter so the wiring is exercised
end-to-end without mocks.

## Why This Matters

**Zero-friction adapter replacement.** When Dynamics 365 is ready, a new
`CRM::Adapters::Dynamics365::Countries` class is added and the default keyword argument
in `CRM::Client::Countries#initialize` is updated. The controller, value object, and all
existing specs are untouched.

**Testability at every layer.** The value object, delegation class, and adapter each have
their own spec. The controller's existing request spec provides full-stack integration
coverage without any modification.

**Stable, small interface contract.** `CRM::Client::Country` is a `Data.define` value
object — immutable and equal by value. The adapter interface is a single `#all` method
returning an array of this type. A small, stable contract is easy to verify and easy to
implement for new adapters.

**Separation of concerns.** Caching lives in the controller. Data sourcing lives in the
adapter. Type definition lives in `CRM::Client`. Each layer has one reason to change.

## When to Apply

- A controller is the first consumer of data that will eventually come from an external
  CRM or third-party service not yet available or integrated.
- Hardcoded data or stub values live directly in a controller with no extraction layer.
- Multiple future data sources are anticipated for the same resource.
- A new resource type is added to the `lookup_items` family — follow the same pattern:
  new value object under `lib/crm/client/`, new delegation class, new demo adapter under
  `lib/crm/adapters/demo/`.

## Examples

**Before — inline struct and hardcoded data in the controller:**

```ruby
class API::LookupItems::CountriesController < API::ApplicationController
  Country = Data.define(:id, :value, :iso_code)

  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      [
        Country.new(id: "3fa85f64-...", value: "United States", iso_code: "US"),
        Country.new(id: "3fa85f64-...", value: "Canada",        iso_code: "CA"),
        # ...
      ]
    end
    render json: { data: data }
  end
end
```

The `Country` type is scoped to the controller and invisible to other consumers. The data
has no independent home. There is no seam for testing or swapping the data source.

**After — controller delegates to `CRM::Client::Countries`:**

```ruby
class API::LookupItems::CountriesController < API::ApplicationController
  def index
    data = Rails.cache.fetch(**cache_options.to_h) do
      CRM::Client::Countries.new.all
    end
    render json: { data: data }
  end
end
```

The controller has no knowledge of the adapter, the value object definition, or the data
source.

**Swapping to Dynamics 365 when it is ready:**

```ruby
# lib/crm/client/countries.rb — one line changes
def initialize(adapter: CRM::Adapters::Dynamics365::Countries.new)
```

No other file changes.

**Directory layout:**

```
lib/crm/
  client/
    country.rb          # Data.define value object — canonical type
    countries.rb        # Delegation class, constructor-injected adapter
  adapters/
    demo/
      countries.rb      # Hardcoded data, returns CRM::Client::Country instances
    dynamics365/        # (future) live CRM integration, same #all interface

spec/lib/crm/
  client/
    country_spec.rb     # Data.define contract: fields, equality, ArgumentError
    countries_spec.rb   # instance_double delegation + smoke test with real adapter
  adapters/demo/
    countries_spec.rb   # Returns 5 CRM::Client::Country instances with correct ISO codes
```

## Related

- Architecture requirements: [`docs/brainstorms/2026-04-24-crm-adapter-architecture-requirements.md`](../../brainstorms/2026-04-24-crm-adapter-architecture-requirements.md)
- Design ideation: [`docs/ideation/2026-04-24-crm-adapter-pattern-ideation.md`](../../ideation/2026-04-24-crm-adapter-pattern-ideation.md)
- Implementation plan: [`docs/plans/2026-04-27-001-feat-demo-crm-adapter-countries-plan.md`](../../plans/2026-04-27-001-feat-demo-crm-adapter-countries-plan.md)
