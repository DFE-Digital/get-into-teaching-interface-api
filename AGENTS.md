# AGENTS.md — get-into-teaching-interface-api

Rails 8 JSON API gateway. Sits between upstream Ruby client services and the
Dynamics 365 CRM API. No end-user UI — all consumers are developers calling via
HTTP.

---

## Commands

```bash
bin/ci                          # full suite: RSpec, RuboCop, brakeman, bundler-audit
bundle exec rspec               # tests only
bundle exec rubocop             # lint only
bundle exec rubocop --autocorrect-all  # autofix lint errors
rails zeitwerk:check            # verify autoload paths after adding lib/ files
bundle exec rladr new <title>   # create a new Architecture Decision Record
```

---

## Tech Stack

- Ruby on Rails 8, PostgreSQL
- `solid_queue` — database-backed Active Job (no Redis)
- `solid_cache` — database-backed Rails cache (2-hour TTL default)
- `rspec-rails`, `factory_bot_rails`, `shoulda-matchers` — test stack
- `rubocop-govuk` + `rubocop-rails-omakase` — linting
- `dfe-analytics` — DFE-standard event analytics (brings Faraday v2 as transitive dep)

---

## Project Structure

```
app/
  controllers/
    api/
      lookup_items/       # API::LookupItems controllers (JSON, namespaced)
    concerns/
      cacheable.rb        # Shared cache concern — 2h TTL, force-miss via param
  jobs/                   # Solid Queue background jobs
  models/                 # Active Record models (minimal by design)
lib/
  crm/
    client/               # CRM::Client — value objects (Data.define) + delegation classes
    adapters/
      demo/               # CRM::Adapters::Demo — hardcoded data, used until Dynamics365 is wired
      dynamics365/        # CRM::Adapters::Dynamics365 — (future) live CRM adapter
spec/
  requests/api/           # Request specs (integration, use named route helpers)
  lib/crm/                # Unit specs for lib/crm/ — mirror the lib/ structure
  support/                # RSpec helpers (FactoryBot, time helpers)
docs/
  solutions/              # Documented solutions — bugs, best practices, workflow patterns.
                          # Organised by category with YAML frontmatter (module, tags, problem_type).
                          # Relevant when implementing or debugging in documented areas.
  brainstorms/            # Requirements and architecture documents
  plans/                  # Implementation plans (status: active | completed)
  ideation/               # Design exploration logs
adr/                      # Architecture Decision Records
```

---

## Key Conventions

### Routes and controllers

- All API routes live under `namespace :api, defaults: { format: :json }`
- Resources are further namespaced by domain: `namespace :lookup_items`
- Controller class: `API::LookupItems::FooController < API::ApplicationController`
- Request spec: `spec/requests/api/lookup_items/foo_spec.rb`
- Use named route helpers in specs (`api_lookup_items_foo_path`)

### CRM adapter pattern

New CRM entities follow the three-layer pattern under `lib/crm/`:

1. **Value object** — `CRM::Client::Foo = Data.define(...)` in `lib/crm/client/foo.rb`
2. **Delegation class** — `CRM::Client::Foos` in `lib/crm/client/foos.rb`, injects adapter via constructor
3. **Adapter** — `CRM::Adapters::Demo::Foos` in `lib/crm/adapters/demo/foos.rb` (hardcoded until Dynamics365 is ready)

Controller calls `CRM::Client::Foos.new.all` inside `Rails.cache.fetch(**cache_options.to_h)`.
Caching stays in the controller — `CRM::Client` is cache-unaware.

See `docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md` for the full pattern with examples.

### Zeitwerk and acronyms

`CRM` and `API` acronyms are registered in `config/initializers/inflections.rb`.
Zeitwerk resolves `CRM::Client` from `lib/crm/client/` automatically. Run
`rails zeitwerk:check` after adding new files under `lib/`.

### Testing

- `spec/rails_helper.rb` sets `verify_partial_doubles: true` — use `instance_double` for adapter doubles
- Clear the cache in request specs: `before { Rails.cache.clear }`
- Unit specs for `lib/crm/` live in `spec/lib/crm/`, mirroring the source tree
- Parsed JSON in request specs: `response.parsed_body` (Rails 7.1+ built-in)

### Architecture decisions

Record significant decisions with `bundle exec rladr new <title>`. ADRs live in `adr/`.
