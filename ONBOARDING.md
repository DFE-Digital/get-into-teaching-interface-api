# Get Into Teaching Interface API Onboarding Guide

This is the `get-into-teaching-interface-api` Rails application. It is
currently in its initial scaffold phase -- the foundation and tooling are in
place, but API routes are not yet implemented.

---

## What Is This?

This app is a lightweight API gateway for the Get Into Teaching (GiT) digital
service. It sits between a collection of upstream Ruby client services and the
Dynamics 365 CRM API that stores teacher recruitment data.

It replaces an existing C# implementation that had become unmaintainable.
Transformation and business logic that previously lived in the C# app is being
moved to the CRM API itself, leaving this Rails app as a thin, well-defined
boundary: it receives requests from consuming services, optionally queues
work that doesn't need to be synchronous, and proxies the rest on to the CRM.

---

## Developer Experience

Upstream services communicate with this app through a shared Ruby client gem.
That gem sends HTTP requests to this API's endpoints, and this app either
responds immediately or places work on a job queue.

Because the app is a gateway, there is no end-user UI. All interaction happens
over HTTP from other services -- the consuming audience is always a developer
integrating via the Ruby client. Once API routes are added, the primary
integration pattern will be:

```
Ruby client (upstream service)
  |
  | HTTP (JSON)
  v
get-into-teaching-interface-api
  |-- synchronous path: proxy to CRM, return response
  `-- async path: enqueue job, return 202 Accepted
```

---

## How Is It Organised?

### System Architecture

```
  Upstream Services (Ruby client)
            |
            | HTTP JSON
            v
+----------------------------+
|  Rails API Gateway         |
|  (Puma + Thruster)         |
|                            |
|  Controllers               |
|     |          |           |
|  Sync path  Async path     |
|     |          |           |
|     |     Solid Queue      |
|     |     (job queue)      |
|     |          |           |
|  Solid Cache (thin cache)  |
+----------------------------+
            |
            | HTTP
            v
+----------------------------+
|  Dynamics 365 CRM API      |
+----------------------------+
            |
            v
+----------------------------+
|  PostgreSQL                |
|  (Solid Queue + Cache      |
|   backing store)           |
+----------------------------+
```

### Directory Structure

```
get-into-teaching-interface-api/
  app/
    controllers/    # Request handling
    jobs/           # Solid Queue background jobs
    models/         # Active Record models
    views/          # Error pages + home stub
  config/
    routes.rb       # Route definitions
    application.rb  # App config
  spec/             # RSpec test suite
  adr/              # Architecture Decision Records
  db/               # Schema and migrations
```

### Key Modules

| Module | Responsibility |
|--------|---------------|
| `app/controllers/` | HTTP request handling; API routes will live here |
| `app/jobs/` | Solid Queue background jobs for async CRM writes |
| `app/models/` | Active Record models; minimal by design |
| `app/controllers/errors_controller.rb` | Renders standard HTTP error responses |
| `adr/` | Architecture Decision Records -- read these first for context |

### External Dependencies

| Dependency | What it's used for | Configured via |
|-----------|-------------------|---------------|
| PostgreSQL | Primary data store; also backs Solid Queue and Solid Cache | `DATABASE_URL` |
| Dynamics 365 CRM API | The downstream CRM this gateway proxies to | TBD (not yet wired) |
| dfe-analytics | DFE-standard event analytics | DFE Analytics config |

Solid Queue and Solid Cache use PostgreSQL as their backing store -- there is
no Redis or separate queue infrastructure to run.

---

## Key Concepts and Abstractions

| Concept | What it means in this codebase |
|---------|-------------------------------|
| API gateway | This app is a thin pass-through, not a business logic layer |
| Solid Queue | Database-backed Active Job adapter; jobs are rows in PostgreSQL |
| Solid Cache | Database-backed Rails cache store; no Redis needed |
| Synchronous path | Controller proxies request to CRM and returns the response immediately |
| Async path | Controller enqueues a job and returns `202 Accepted`; job handles CRM call |
| ADR | Architecture Decision Record in `adr/`; captures *why* decisions were made |
| DFE Rails template | The opinionated scaffold this app was generated from -- see [ADR 00002](adr/00002-use-dfe-rails-template.md) |
| Thruster | Rack middleware layer wrapping Puma; adds HTTP caching headers and compression |
| rubocop-govuk | GOV.UK-standard RuboCop ruleset applied on top of `rubocop-rails-omakase` |

---

## Primary Flows

### Synchronous API Request (not yet implemented)

This is the intended request path once API routes are added:

```
Ruby client HTTP request
  |
  v
config/routes.rb
  matches route, dispatches to controller
  |
  v
app/controllers/<resource>_controller.rb
  validates params, checks cache
  |
  v
CRM API HTTP call
  (via service object, TBD)
  |
  v
Response returned to client (JSON)
```

### Async Job Enqueue (not yet implemented)

For writes that don't require an immediate CRM response:

```
Ruby client HTTP request
  |
  v
app/controllers/<resource>_controller.rb
  enqueues job, returns 202 Accepted
  |
  v
app/jobs/<resource>_job.rb
  (executed by Solid Queue worker)
  |
  v
CRM API HTTP call
```

### Current live paths

Only two routes currently respond:

- `GET /up` -- Rails health check, returns `200` if the app boots cleanly
- `GET /404`, `/422`, `/429`, `/500` -- Standard error renderers via
  `ErrorsController`

---

## Developer Guide

### Setup

You need `asdf` with Ruby and Node plugins, and a running PostgreSQL instance.

```bash
git clone <repository-url>
cd get-into-teaching-interface-api
asdf install        # installs Ruby 4.0.3 and Node 24.15.0
bin/setup           # gems, JS packages, DB setup, dev server
```

`bin/setup` is idempotent -- run it again after pulling changes to update
dependencies and run pending migrations.

### Running and Testing

```bash
bin/setup           # start the dev server
bin/ci              # run tests and linters
bin/rubocop         # lint only
bin/rubocop --autocorrect-all  # autofix lint errors
```

### IDE Support (Solargraph)

After install, index your bundle once for autocomplete:

```bash
bundle exec yard gems
```

Configure your editor to use `"solargraph.useBundler": true`.

### Common Change Patterns

- **Add an API route**: define the route in `config/routes.rb`, create a
  controller in `app/controllers/`, add a request spec in `spec/requests/`.
- **Add a background job**: create a job class in `app/jobs/` inheriting from
  `ApplicationJob`; Solid Queue picks it up automatically.
- **Record an architecture decision**: `bundle exec rladr new <title>` creates
  a new ADR in `adr/`.

### Key Files to Start With

| Area | File | Why |
|------|------|-----|
| Routes | `config/routes.rb` | All URL surface area is here |
| App config | `config/application.rb` | Framework modules, autoload config |
| Error handling | `app/controllers/errors_controller.rb` | Pattern for error responses |
| ADRs | `adr/` | Context for every significant decision |
| CI script | `bin/ci` | Understand what the test suite runs |

### Security Tooling

`brakeman` (static analysis) and `bundler-audit` (dependency CVE checks) are
included in the dev/test group and run as part of `bin/ci`. Neither requires
configuration to use.
