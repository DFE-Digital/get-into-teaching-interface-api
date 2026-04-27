---
date: 2026-04-24
topic: crm-adapter-architecture
updated: 2026-04-27
---

# CRM Adapter Architecture

## Problem Frame

This app is a lightweight Rails API gateway that sits between upstream Ruby client
services and the Dynamics 365 CRM API. The Dynamics 365 API is still under active
development. The app needs a clean, testable CRM integration layer that:

- Can be tested without hitting the real CRM API
- Isolates transformation logic in one place
- Makes the contract between this app and the CRM explicit and enforceable
- Is easy to extend as new CRM operations are added

The C# predecessor this app replaces lacked this separation, which contributed to
its unmaintainability.

## Architecture Overview

Three layers sit between the controller and the CRM API, each with a single
responsibility:

```
Controller
    │
    ▼
CRM::Client::<Entity>
  owns type definitions, sets the shape contract
    │
    ▼
CRM::Adapters::Dynamics365::<Entity>
  transforms raw JSON → typed CRM::Client objects
    │
    ▼
CRM::Dynamics365Client
  raw HTTP via Faraday, returns parsed JSON hashes
    │
    ▼
Dynamics 365 CRM API
```

### Request flow example

```
GET /api/teaching_events/regions
    │
    ▼ routes.rb
TeachingEventsController#regions
    │
    ▼ CRM::Client::TeachingEvent.new.regions
CRM::Client::TeachingEvent
  returns Array<CRM::Client::Region>
    │
    ▼ adapter.regions
CRM::Adapters::Dynamics365::TeachingEvent
  maps raw JSON → CRM::Client::Region objects
    │
    ▼ client.get("/teaching_events/regions")
CRM::Dynamics365Client
  Faraday HTTP call → parsed JSON hash
    │
    ▼
Dynamics 365 CRM API
```

---

## Requirements

**CRM::Client — contract and type definitions**

- R1. `CRM::Client` defines the value object types for all CRM entities using
  `Data.define` (e.g. `CRM::Client::Region = Data.define(:id, :name)`). These
  types are the canonical data contract — no other layer defines entity shapes.
- R2. `CRM::Client::<Entity>` classes are thin delegation objects that call through
  to an injected adapter and return typed value objects. Controllers program
  against `CRM::Client` only; they never reference `CRM::Adapters::Dynamics365` directly.
- R3. The adapter is injected into `CRM::Client::<Entity>` at construction with a
  sensible default (the `CRM::Adapters::Dynamics365` counterpart), so tests can inject a
  double without environment switching.

**CRM::Adapters::Dynamics365 — transformation layer**

- R4. `CRM::Adapters::Dynamics365::<Entity>` classes are responsible for transforming
  raw JSON hashes (returned by `CRM::Dynamics365Client`) into the typed value objects
  defined by `CRM::Client`. No transformation logic lives in `CRM::Dynamics365Client`
  or `CRM::Client`. Adapter class names mirror their `CRM::Client` counterparts
  exactly (e.g. `CRM::Client::TeachingEvent` → `CRM::Adapters::Dynamics365::TeachingEvent`).
- R5. `CRM::Adapters::Dynamics365::<Entity>` classes receive a `CRM::Dynamics365Client`
  instance via constructor injection (with a default), so they can be unit-tested
  by injecting a double without making real HTTP calls.

**CRM::Dynamics365Client — HTTP layer**

- R7. `CRM::Dynamics365Client` makes raw HTTP calls to the Dynamics 365 API using
  Faraday and returns parsed JSON hashes. It has no knowledge of `CRM::Client` types
  or domain concepts.
- R8. `CRM::Dynamics365Client` accepts an optional Faraday connection at construction
  to allow Faraday-level stubbing in tests without subclassing or monkey-patching.
- R9. The Faraday connection used by `CRM::Dynamics365Client` in production includes
  JSON request/response middleware so callers always work with Ruby hashes, not
  raw HTTP response bodies.

**Testing strategy**

- R10. Unit tests for `CRM::Adapters::Dynamics365::<Entity>` inject a
  `CRM::Dynamics365Client` double and assert that raw JSON hashes are correctly
  transformed into the expected `CRM::Client` typed objects.
- R11. Unit tests for `CRM::Client::<Entity>` inject a `CRM::Adapters::Dynamics365`
  double and assert delegation behaviour.
- R12. Integration tests use VCR cassettes to record and replay real Dynamics 365
  HTTP responses. Cassettes live in `spec/cassettes/`.
- R13. For fast in-process tests that need controlled HTTP responses without VCR
  cassettes, Faraday's built-in stub adapter is used (as enabled by R8, which
  allows a test connection to be passed at construction).

**File layout**

- R14. `CRM::Dynamics365Client` lives in `lib/crm/dynamics365_client.rb`.
- R15. `CRM::Adapters::Dynamics365` entity classes live under
  `lib/crm/adapters/dynamics365/<entity>.rb`, mirroring the `CRM::Client` namespace.
- R16. `CRM::Client` entity classes live under `lib/crm/client/<entity>.rb`. Each
  value object type (e.g. `CRM::Client::Region`) lives in its own file matching
  its constant name (e.g. `lib/crm/client/region.rb`), not nested inside an
  entity file.

---

## Code Sketches

These sketches illustrate the shape of each layer. Exact field names and
Dynamics 365 endpoint paths are resolved during implementation.

### CRM::Client

```ruby
# lib/crm/client/teaching_event.rb
module CRM
  module Client
    Region = Data.define(:id, :name)

    class TeachingEvent
      def initialize(adapter: CRM::Adapters::Dynamics365::TeachingEvent.new)
        @adapter = adapter
      end

      def regions
        @adapter.regions
      end
    end
  end
end
```

### CRM::Adapters::Dynamics365

```ruby
# lib/crm/adapters/dynamics365/teaching_event.rb
module CRM
  module Adapters
    module Dynamics365
      class TeachingEvent
        def initialize(client: CRM::Dynamics365Client.new)
          @client = client
        end

        def regions
          response = @client.get("/teaching_events/regions")
          response["regions"].map do |r|
            CRM::Client::Region.new(id: r["id"], name: r["name"])
          end
        end
      end
    end
  end
end
```

### CRM::Dynamics365Client

```ruby
# lib/crm/dynamics365_client.rb
module CRM
  class Dynamics365Client
    def initialize(connection: default_connection)
      @connection = connection
    end

    def get(path)
      response = @connection.get(path)
      response.body
    end

    private

    def default_connection
      Faraday.new(url: ENV["DYNAMICS365_API_URL"]) do |f|
        f.request :json
        f.response :json
        f.response :raise_error
      end
    end
  end
end
```

### Test — adapter unit test with injected client double

```ruby
# spec/lib/crm/adapters/dynamics365/teaching_event_spec.rb
RSpec.describe CRM::Adapters::Dynamics365::TeachingEvent do
  subject(:adapter) { described_class.new(client: client_double) }

  let(:client_double) { instance_double(CRM::Dynamics365Client) }

  describe "#regions" do
    before do
      allow(client_double).to receive(:get)
        .with("/teaching_events/regions")
        .and_return({ "regions" => [{ "id" => "1", "name" => "London" }] })
    end

    it "returns typed Region objects" do
      expect(adapter.regions).to eq([ CRM::Client::Region.new(id: "1", name: "London") ])
    end
  end
end
```

### Test — Faraday stub for integration tests

```ruby
# spec/support/faraday_stubs.rb
def stub_dynamics365_connection
  Faraday.new do |f|
    f.request :json
    f.response :json
    f.response :raise_error
    f.adapter :test do |stub|
      yield stub
    end
  end
end

# In a spec:
let(:connection) { stub_dynamics365_connection { |s| s.get("/teaching_events/regions") { [200, {}, { "regions" => [...] }] } } }
let(:client) { CRM::Dynamics365Client.new(connection: connection) }
```

### Minitest equivalents

The project currently uses RSpec (`rspec-rails` is in the `Gemfile`). The
equivalent tests in Minitest are shown below for comparison.

**Adapter unit test (Minitest::Mock)**

```ruby
# test/lib/crm/adapters/dynamics365/teaching_event_test.rb
class CRM::Adapters::Dynamics365::TeachingEventTest < ActiveSupport::TestCase
  def test_regions_returns_typed_region_objects
    client = Minitest::Mock.new
    client.expect(:get,
      { "regions" => [{ "id" => "1", "name" => "London" }] },
      ["/teaching_events/regions"])

    adapter = CRM::Adapters::Dynamics365::TeachingEvent.new(client: client)
    expected = [ CRM::Client::Region.new(id: "1", name: "London") ]

    assert_equal expected, adapter.regions
    client.verify
  end
end
```

**Faraday stub integration test (Minitest)**

```ruby
# test/integration/teaching_event_integration_test.rb
class TeachingEventIntegrationTest < ActiveSupport::TestCase
  def test_regions_via_faraday_stub
    connection = stub_dynamics365_connection do |stub|
      stub.get("/teaching_events/regions") do
        [200, {}, { "regions" => [{ "id" => "1", "name" => "London" }] }]
      end
    end
    client  = CRM::Dynamics365Client.new(connection: connection)
    adapter = CRM::Adapters::Dynamics365::TeachingEvent.new(client: client)

    assert_equal [ CRM::Client::Region.new(id: "1", name: "London") ],
                 adapter.regions
  end
end
```

**RSpec vs Minitest tradeoffs for this pattern**

| Concern | RSpec | Minitest |
|---------|-------|----------|
| Syntax overhead | `describe`/`it` nesting | Plain Ruby classes, `def test_` |
| Mock verification | Automatic on example completion | Must call `mock.verify` explicitly |
| Signature checking | `instance_double` verifies method signatures exist | `Minitest::Mock` does not |
| Contract testing | `it_behaves_like` shared examples are idiomatic | Requires modules included into test classes — works but less ergonomic |
| Failure messages | Richer contextual diffs | Terse `assert_equal` output |
| Dependencies | `rspec-rails` (already present) | Ships with Ruby stdlib |

The primary practical consequence for this architecture: the RSpec shared-examples
approach (where every adapter must pass `it_behaves_like "a CRM adapter"`) is
notably more ergonomic in RSpec. Minitest can replicate it with a shared module
(`include CRMAdapterContract`), but the idiom is less established.

Given `rspec-rails` is already in the `Gemfile`, RSpec is the recommended choice
unless the team decides to standardise on Minitest across all DFE services.

---

## Success Criteria

- A new CRM operation can be added by creating one `CRM::Client` method, one
  `CRM::Adapters::Dynamics365` method, and one `CRM::Dynamics365Client` call — with no
  changes to any other layer.
- `CRM::Adapters::Dynamics365` specs pass without network access.
- `CRM::Client` specs pass without using a real adapter instance (a test double is
  injected in place of the default).
- VCR cassettes cover at least the happy path for each CRM operation.
- No `CRM::Adapters::Dynamics365` or `CRM::Dynamics365Client` references appear outside
  `lib/` and `spec/`.

---

## Scope Boundaries

- The normalised error taxonomy (`CRM::NotFoundError` etc.) is a related idea
  from ideation but is out of scope here. It should be designed separately.
- Idempotency keys for async Solid Queue writes are out of scope here.
- Authentication to the Dynamics 365 API (OAuth tokens etc.) is deferred to
  planning — the Faraday connection setup is a placeholder.
- No registry or environment-driven adapter switching is introduced. Test
  isolation is handled entirely at the Faraday level.

---

## Key Decisions

- **Three layers, not two**: A dedicated `CRM::Dynamics365Client` HTTP layer is
  introduced alongside the adapter. This keeps transformation logic separate from
  HTTP concerns and makes both independently testable.
- **Faraday + VCR for test isolation**: No stub adapter class. Tests stub at the
  HTTP level using Faraday's built-in stub adapter or VCR cassettes.
- **`CRM::Client` owns the types**: Value object definitions (`Data.define`) live in
  `CRM::Client`, not in the adapter. The adapter's job is transformation into those
  types, not definition of them.
- **Constructor injection throughout**: Each layer accepts its dependency via
  constructor with a default, enabling doubles at every seam without environment
  flags.
- **`lib/crm/` as the top-level namespace**: All CRM code lives under `lib/crm/`,
  giving the `CRM` module as the top-level namespace. Zeitwerk resolves this via the
  `inflect.acronym "CRM"` rule already registered in `config/initializers/inflections.rb`.
  Adapters are grouped under `lib/crm/adapters/` so future adapters (Demo, Dynamics365,
  etc.) sit alongside each other.

---

## Dependencies / Assumptions

- `faraday` is present as a transitive dependency of `dfe-analytics` (confirmed
  in `Gemfile.lock` at v2.14.1). Add it as a direct `Gemfile` entry to prevent
  version drift if `dfe-analytics` drops or changes it.
- `vcr` and `webmock` are confirmed absent from the `Gemfile`; both must be
  added to the `:test` group.
- Dynamics 365 API base URL and authentication details are available via
  environment variables (specific var names TBD).

---

## Outstanding Questions

### Deferred to Planning

- [Affects R7, R9][Needs research] What authentication mechanism does the
  Dynamics 365 API require? (OAuth2 client credentials? API key?) The Faraday
  middleware stack and `CRM::Dynamics365Client` setup depend on this.
- [Affects R7][Technical] Should `CRM::Dynamics365Client` be a singleton (configured
  once at boot) or instantiated per request? Does the Faraday connection need to
  manage token refresh?
- [Affects R12][Technical] What VCR configuration is needed (cassette serialiser,
  record mode, sensitive header filtering for auth tokens)?
- [Affects R4][Needs research] What do Dynamics 365 JSON field names look like for
  the first entities to be implemented? (OData-style names like
  `msdyncrm_emailaddress1` will need explicit mapping in the adapter.)

### Resolved

- [Affects R14, R15, R16][Technical] **RESOLVED 2026-04-27.** Zeitwerk resolves
  `CRM` correctly via `inflect.acronym "CRM"` already registered in
  `config/initializers/inflections.rb`. The final namespace structure is
  `CRM::Client` (`lib/crm/client/`), `CRM::Adapters::Demo` (`lib/crm/adapters/demo/`),
  and `CRM::Adapters::Dynamics365` (`lib/crm/adapters/dynamics365/`) — all confirmed
  with `rails zeitwerk:check`.

---

## Next Steps

-> `/ce:plan` for structured implementation planning
