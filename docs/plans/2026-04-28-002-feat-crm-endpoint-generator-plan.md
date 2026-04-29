---
title: "feat: Rails generator for CRM adapter endpoints"
type: feat
status: active
date: 2026-04-28
origin: docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md
---

# feat: Rails generator for CRM adapter endpoints

## Overview

Adding ~30 CRM adapter endpoints by hand would require creating 8–14 files per endpoint, modifying 3–6 existing files, and maintaining strict structural consistency across four layers (abstract bases, demo adapter, GetIntoTeaching adapter, controller). This plan introduces a Rails generator that accepts an endpoint path and produces the complete, correct file set for that path — creating new files where nothing exists and inserting methods into existing files where a parent resource has already been generated.

The generator handles two URL depths:
- **2-level** — `lookup_items/countries` → 2 path segments below `/api/`
- **3-level** — `pick_list_items/candidate/initial_teacher_training_years` → 3 path segments below `/api/`

## Problem Frame

The CRM adapter pattern is well-defined (see solution doc) but tedious to extend by hand. The pattern is uniform enough that every new endpoint requires exactly the same 4-layer structure — abstract base, demo stub, GetIntoTeaching HTTP resource, controller — with only namespace names and file paths varying. A generator encodes that structure once and eliminates transcription errors.

## Requirements Trace

- R1. Running `rails generate crm_endpoint <path>` produces all files needed for a working endpoint
- R2. The generator supports both 2-level paths (`list_type/collection`) and 3-level paths (`list_type/category/collection`)
- R3. Re-running the generator for a second endpoint under the same list_type or category does not duplicate existing files or methods
- R4. The value object is always `Data.define(:id, :value)` — no other fields
- R5. The generator generates spec files for every file it creates
- R6. Routes are updated automatically

## Scope Boundaries

- The generator does not run `rails zeitwerk:check` automatically — that is the developer's responsibility after running it
- VCR cassettes are not generated — recording a real HTTP interaction is out of scope for a generator
- No generator for modifying the adapter selector in `CRM::Client` — it already defaults to Demo and stays that way
- No dry-run (`--pretend`) support is required, though Rails generators provide it for free

## Context & Research

### Relevant Code and Patterns

- Solution doc encoding the full pattern: `docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md`
- Abstract base for 2-level grouper: `lib/crm/resources/look_up_items_resource.rb`
- Abstract collection base: `lib/crm/resources/look_up_items/countries_resource.rb`
- Value object: `lib/crm/resources/look_up_items/country_resource.rb`
- Demo collection resource: `lib/crm/adapters/demo/resources/look_up_items/countries_resource.rb`
- GetIntoTeaching collection resource: `lib/crm/adapters/get_into_teaching/resources/look_up_items/countries_resource.rb`
- Demo grouper resource (method insertion target): `lib/crm/adapters/demo/resources/look_up_items_resource.rb`
- GetIntoTeaching grouper resource (method insertion target): `lib/crm/adapters/get_into_teaching/resources/look_up_items_resource.rb`
- Facade (method insertion target): `lib/crm/client.rb`
- Demo client (method insertion target): `lib/crm/adapters/demo/client.rb`
- GetIntoTeaching client (method insertion target): `lib/crm/adapters/get_into_teaching/client.rb`
- Routes (insertion target): `config/routes.rb`
- Controller example: `app/controllers/api/lookup_items/countries_controller.rb`

### Institutional Learnings

- Zeitwerk requires acronym registration for any new uppercase directory name — the generator must not create directories with unregistered acronyms (see solution doc §Zeitwerk)
- `response_to_collection` returns a plain Ruby array; `{ data: }` envelope belongs only in the controller
- VCR cassette names must be explicit strings, not derived from RSpec example descriptions

### External References

- Rails generators guide: https://guides.rubyonrails.org/generators.html
- Thor `insert_into_file` and `gsub_file` are the standard tools for modifying existing files from a generator

## Key Technical Decisions

- **Rails generator, not a standalone script**: integrates with `rails generate`, supports `--pretend` dry-run for free, follows Rails conventions for `SOURCE_ROOT` and template lookup. Invoked as `rails generate crm_endpoint pick_list_items/candidate/initial_teacher_training_years`.
- **Single generator class with depth branching**: a single `CrmEndpointGenerator` derives depth from argument segment count (2 = 2-level, 3 = 3-level). Separate templates per layer handle the differing module nesting at template render time.
- **Idempotent create-then-insert pattern**: for each output file, check existence before creating. For each method insertion into an existing file, check whether the method already appears before calling `insert_into_file`. This makes re-running the generator for a second endpoint under the same parent safe.
- **Value object always `Data.define(:id, :value)`**: the generator does not accept field arguments. If a specific endpoint needs extra fields (e.g., `iso_code`), the developer edits the generated file manually.
- **Route modification via `insert_into_file` with regex anchors**: rather than appending to routes.rb, the generator finds the innermost matching namespace block and inserts inside it. For a brand-new list_type, it inserts a complete namespace block inside the `api` namespace. Falls back to appending a comment-marked block if the anchor regex fails.
- **Spec generation covers all created files**: every generated file gets a corresponding spec. The generator does not generate VCR cassettes or request specs for the GetIntoTeaching adapter (those require real HTTP interactions and are developer-owned).

## Open Questions

### Resolved During Planning

- **Who generates the request spec?** The generator produces a request spec for the controller (`spec/requests/api/<path>_spec.rb`) but not VCR cassettes. The developer records cassettes manually once GIT credentials are available.
- **What if the developer needs `iso_code` or other fields?** The generator hardcodes `Data.define(:id, :value)`. The developer edits the generated file. Accepting field arguments in the generator adds complexity that is not warranted for a one-time batch of ~30 endpoints.
- **3-level route nesting depth**: Rails handles 3-level `namespace` nesting correctly. No routing constraint prevents this.

### Deferred to Implementation

- **Regex anchor stability for route insertion**: the exact regex patterns for finding the right namespace block in routes.rb must be validated against the actual file during implementation. If the patterns prove unreliable, fall back to appending a clearly commented block at the end of the `api` namespace.
- **Method insertion `before:` anchor**: inserting a method before the last `end` in a class body must be tested against files that already have multiple methods. The anchor pattern (e.g., matching the final `      end\n    end\n  end\nend`) must be confirmed during implementation.

## High-Level Technical Design

> *This illustrates the intended approach and is directional guidance for review, not implementation specification. The implementing agent should treat it as context, not code to reproduce.*

### Name derivation from input path

Given `pick_list_items/candidate/initial_teacher_training_years`:
```
segments      = ["pick_list_items", "candidate", "initial_teacher_training_years"]
depth         = 3
list_type     = "pick_list_items"        # segments[0]
category      = "candidate"              # segments[1]  (nil for depth 2)
collection    = "initial_teacher_training_years"   # segments[-1]
singular      = "initial_teacher_training_year"    # ActiveSupport::Inflector.singularize(collection)
```

Class name helpers (using `camelize`):
```
list_type_class    = "PickListItemsResource"
category_class     = "CandidateResource"
collection_class   = "InitialTeacherTrainingYearsResource"
singular_class     = "InitialTeacherTrainingYearResource"
```

### Generator decision logic (per layer)

```
for each layer in [abstract, demo, git, controller, specs]:

  if list_type resource file absent:
    create it from template (includes method stub for category or collection)
  else if method for category/collection absent in file:
    insert_into_file (add method before closing end)

  if depth == 3 and category resource file absent:
    create it from template (includes method stub for collection)
  else if depth == 3 and method for collection absent in file:
    insert_into_file

  create collection resource file (always new — leaf node)
  create value object file (always new — leaf node)

modify routes.rb:
  if api > list_type namespace absent → insert complete block inside api namespace
  else if depth == 3 and category namespace absent → insert inside list_type block
  else → insert resources line inside innermost matching block

insert #list_type method into CRM::Client, Demo::Client, GIT::Client if absent
```

### File manifest for 3-level path `pick_list_items/candidate/initial_teacher_training_years`

| Action | File |
|--------|------|
| create or modify | `lib/crm/resources/pick_list_items_resource.rb` |
| create or modify | `lib/crm/resources/pick_list_items/candidate_resource.rb` |
| create | `lib/crm/resources/pick_list_items/candidate/initial_teacher_training_year_resource.rb` |
| create | `lib/crm/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb` |
| create or modify | `lib/crm/adapters/demo/resources/pick_list_items_resource.rb` |
| create or modify | `lib/crm/adapters/demo/resources/pick_list_items/candidate_resource.rb` |
| create | `lib/crm/adapters/demo/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb` |
| create or modify | `lib/crm/adapters/get_into_teaching/resources/pick_list_items_resource.rb` |
| create or modify | `lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate_resource.rb` |
| create | `lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb` |
| create | `app/controllers/api/pick_list_items/candidate/initial_teacher_training_years_controller.rb` |
| modify | `config/routes.rb` |
| modify | `lib/crm/client.rb` (if `pick_list_items` method absent) |
| modify | `lib/crm/adapters/demo/client.rb` (if `pick_list_items` method absent) |
| modify | `lib/crm/adapters/get_into_teaching/client.rb` (if `pick_list_items` method absent) |
| create | `spec/lib/crm/resources/pick_list_items_resource_spec.rb` (or modify) |
| create | `spec/lib/crm/resources/pick_list_items/candidate_resource_spec.rb` (or modify) |
| create | `spec/lib/crm/resources/pick_list_items/candidate/initial_teacher_training_year_resource_spec.rb` |
| create | `spec/lib/crm/resources/pick_list_items/candidate/initial_teacher_training_years_resource_spec.rb` |
| create | `spec/lib/crm/adapters/demo/resources/pick_list_items_resource_spec.rb` (or modify) |
| create | `spec/lib/crm/adapters/demo/resources/pick_list_items/candidate_resource_spec.rb` (or modify) |
| create | `spec/lib/crm/adapters/demo/resources/pick_list_items/candidate/initial_teacher_training_years_resource_spec.rb` |
| create | `spec/lib/crm/adapters/get_into_teaching/resources/pick_list_items_resource_spec.rb` (or modify) |
| create | `spec/lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate_resource_spec.rb` (or modify) |
| create | `spec/lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate/initial_teacher_training_years_resource_spec.rb` |
| create | `spec/requests/api/pick_list_items/candidate/initial_teacher_training_years_spec.rb` |

## Implementation Units

- [ ] **Unit 1: Generator skeleton and name derivation helpers**

**Goal:** Create the generator class with argument handling, name derivation helpers, and `SOURCE_ROOT` pointed at the templates directory. The generator should be fully usable as `rails generate crm_endpoint <path>` after this unit.

**Requirements:** R1, R2

**Dependencies:** None

**Files:**
- Create: `lib/generators/crm_endpoint/crm_endpoint_generator.rb`
- Test: `spec/generators/crm_endpoint_generator_spec.rb`

**Approach:**
- Subclass `Rails::Generators::Base`
- Single string argument `endpoint_path`
- Parse segments, derive `list_type`, `category` (nil for 2-level), `collection`, `singular`
- Expose helpers: `module_path_for(layer)`, `file_path_for(layer)`, `class_name_for(segment)`, `depth`
- `SOURCE_ROOT = File.expand_path("templates", __dir__)`
- At this stage, the generator's `source` method may call `raise NotImplementedError` — the goal is the parsing skeleton

**Patterns to follow:**
- Standard Rails generator at `lib/generators/<name>/<name>_generator.rb`
- `ActiveSupport::Inflector.camelize` and `.singularize` for name derivation

**Test scenarios:**
- Happy path: parsing `"lookup_items/countries"` → `list_type="lookup_items"`, `category=nil`, `collection="countries"`, `singular="country"`, `depth=2`
- Happy path: parsing `"pick_list_items/candidate/initial_teacher_training_years"` → `list_type="pick_list_items"`, `category="candidate"`, `collection="initial_teacher_training_years"`, `singular="initial_teacher_training_year"`, `depth=3`
- Edge case: 1 segment raises `ArgumentError` ("path must have 2 or 3 segments")
- Edge case: 4+ segments raises `ArgumentError`
- Happy path: `class_name_for("look_up_items")` → `"LookUpItemsResource"`
- Happy path: `class_name_for("initial_teacher_training_years")` → `"InitialTeacherTrainingYearsResource"`

**Verification:**
- `rails generate crm_endpoint --help` prints the expected usage line
- `rails generate crm_endpoint too/many/segments/here` exits with a clear error message

---

- [ ] **Unit 2: ERB templates for all generated file types**

**Goal:** Create the full set of ERB template files that the generator will render. Templates must correctly handle both depth-2 and depth-3 module nesting via template variables set by the generator.

**Requirements:** R1, R2, R4

**Dependencies:** Unit 1 (name helpers must be defined to validate template variable names)

**Files:**
- Create: `lib/generators/crm_endpoint/templates/abstract_list_type_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/abstract_category_resource.rb.tt` *(3-level only)*
- Create: `lib/generators/crm_endpoint/templates/abstract_collection_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/value_object.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/demo_list_type_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/demo_category_resource.rb.tt` *(3-level only)*
- Create: `lib/generators/crm_endpoint/templates/demo_collection_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/git_list_type_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/git_category_resource.rb.tt` *(3-level only)*
- Create: `lib/generators/crm_endpoint/templates/git_collection_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/controller.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_abstract_list_type_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_abstract_category_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_abstract_collection_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_value_object.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_demo_list_type_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_demo_category_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_demo_collection_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_git_collection_resource.rb.tt`
- Create: `lib/generators/crm_endpoint/templates/spec_request.rb.tt`

**Approach:**
- Each template mirrors the corresponding hand-written file for the `countries` or `teaching_subjects` endpoint, generalised using ERB variables: `<%= list_type_class %>`, `<%= collection_class %>`, `<%= singular_class %>`, `<%= category_class %>` (where applicable)
- The abstract list_type resource template emits a single `def <method_name>(*) = raise NotImplementedError` stub — one per call, so when the file is first created it has exactly one method; subsequent additions use `insert_into_file`
- The demo collection resource template emits 2 hardcoded stub entries using `Data.define(:id, :value)` (no `iso_code`)
- The GIT collection resource template emits a `get_request` call to `/api/<path>` derived from the input segments
- The controller template emits a single `index` action following the existing controller pattern exactly, adapting the fluent call chain for depth (`CRM::Client.new.lookup_items.countries.all` for 2-level vs `CRM::Client.new.pick_list_items.candidate.initial_teacher_training_years.all` for 3-level)
- The request spec template mirrors `spec/requests/api/lookup_items/countries_spec.rb` (assert 200, JSON content-type, `data` key present)

**Technical design:**

Template variable set passed to every render call (directional — not specification):
```
list_type              "pick_list_items"
list_type_class        "PickListItemsResource"
category               "candidate"               # nil for depth-2
category_class         "CandidateResource"       # nil for depth-2
collection             "initial_teacher_training_years"
collection_class       "InitialTeacherTrainingYearsResource"
singular               "initial_teacher_training_year"
singular_class         "InitialTeacherTrainingYearResource"
api_path               "/api/pick_list_items/candidate/initial_teacher_training_years"
fluent_chain           "CRM::Client.new.pick_list_items.candidate.initial_teacher_training_years.all"
```

**Patterns to follow:**
- `lib/crm/adapters/demo/resources/look_up_items/countries_resource.rb` — demo collection template shape
- `lib/crm/adapters/get_into_teaching/resources/look_up_items/countries_resource.rb` — GIT collection template shape
- `app/controllers/api/lookup_items/countries_controller.rb` — controller template shape
- `lib/crm/resources/look_up_items_resource.rb` — abstract grouper template shape

**Test scenarios:**
- Test expectation: none — templates are ERB text; correctness is validated by the generated output tests in Units 3–5

**Verification:**
- Every template file exists and is parseable ERB (no syntax errors; render with dummy variables)

---

- [ ] **Unit 3: Abstract base layer generation**

**Goal:** Wire the generator to produce all files under `lib/crm/resources/` and `spec/lib/crm/resources/`, and to insert missing methods into existing files in that layer.

**Requirements:** R1, R2, R3, R5

**Dependencies:** Units 1, 2

**Files:**
- Modify: `lib/generators/crm_endpoint/crm_endpoint_generator.rb`
- Test: `spec/generators/crm_endpoint_generator_spec.rb`

**Approach:**
- Implement `generate_abstract_layer` method on the generator class
- For `<list_type>_resource.rb`: if absent, call `template` to render `abstract_list_type_resource.rb.tt` to the correct path; if present, check whether the method body contains the new method name, and if not, call `insert_into_file` using a `:before` anchor that matches the final `end` of the class body
- For `<category>_resource.rb` (depth-3 only): same create-or-insert pattern
- For `<collection>_resource.rb` and `<singular>_resource.rb`: always create (leaf nodes — there will never be a pre-existing file for a new collection)
- Mirror the same create-or-insert logic for spec files under `spec/lib/crm/resources/`

**Technical design:**

Idempotency guard for method insertion (directional):
```ruby
def method_exists_in_file?(file_path, method_name)
  File.read(file_path).include?("def #{method_name}")
end

unless method_exists_in_file?(target_path, new_method_name)
  insert_into_file target_path, method_snippet, before: closing_anchor
end
```
The `closing_anchor` is a regex matching the class's last `end` preceded by newline+spaces — exact pattern to be validated during implementation.

**Patterns to follow:**
- `lib/crm/resources/look_up_items_resource.rb` — shape of the abstract grouper (endpoint pattern to mirror)
- `lib/crm/resources/look_up_items/countries_resource.rb` — abstract collection shape

**Test scenarios:**
- Happy path (depth-2): running the generator for `lookup_items/subjects` creates `lib/crm/resources/look_up_items/subjects_resource.rb`, `lib/crm/resources/look_up_items/subject_resource.rb`, and adds `def subjects(*) = raise NotImplementedError` to `lib/crm/resources/look_up_items_resource.rb`
- Happy path (depth-3): running the generator for `pick_list_items/candidate/initial_teacher_training_years` creates the 4 files listed in the manifest and adds `def candidate(*) = raise NotImplementedError` to the new `pick_list_items_resource.rb`
- Idempotency (depth-3): running the generator a second time for `pick_list_items/candidate/preferred_education_phases` adds `def preferred_education_phases(*) = raise NotImplementedError` to `candidate_resource.rb` without duplicating `def candidate` in `pick_list_items_resource.rb`
- Idempotency: running the exact same generator invocation twice does not create duplicate methods or overwrite files
- Edge case: the `before:` anchor must not match an `end` inside a method body — validate against a file with multiple methods

**Verification:**
- `rails zeitwerk:check` passes after running the generator against a clean branch
- Generated spec files follow the RSpec `NotImplementedError` contract pattern from existing specs

---

- [ ] **Unit 4: Demo and GetIntoTeaching adapter layer generation**

**Goal:** Wire the generator to produce all files under `lib/crm/adapters/demo/` and `lib/crm/adapters/get_into_teaching/`, and to insert missing methods into existing adapter resource files and client files.

**Requirements:** R1, R2, R3, R5

**Dependencies:** Unit 3

**Files:**
- Modify: `lib/generators/crm_endpoint/crm_endpoint_generator.rb`
- Test: `spec/generators/crm_endpoint_generator_spec.rb`

**Approach:**
- Implement `generate_demo_layer` and `generate_git_layer` following the same create-or-insert pattern as Unit 3
- For each adapter's `<list_type>_resource.rb`: create if absent (with one method stub); insert method stub if present and method absent
- For each adapter's `<category>_resource.rb` (depth-3): same pattern
- For each adapter's `<collection>_resource.rb`: always create (leaf node)
- For `lib/crm/adapters/demo/client.rb`, `lib/crm/adapters/get_into_teaching/client.rb`, and `lib/crm/client.rb`: check if a `def <list_type>` method exists; if not, insert it using `insert_into_file`
- Spec files for each generated adapter file follow the same create-or-insert pattern

**Technical design:**

Client method insertion inserts before the last `end` in the class body:
```ruby
# Inserted into lib/crm/client.rb
def pick_list_items
  @adapter.pick_list_items
end
```
```ruby
# Inserted into lib/crm/adapters/demo/client.rb
def pick_list_items
  Resources::PickListItemsResource.new
end
```
```ruby
# Inserted into lib/crm/adapters/get_into_teaching/client.rb
def pick_list_items
  Resources::PickListItemsResource.new(self)
end
```

**Patterns to follow:**
- `lib/crm/adapters/demo/resources/look_up_items_resource.rb` — demo grouper method style
- `lib/crm/adapters/get_into_teaching/resources/look_up_items_resource.rb` — GIT grouper method style (single-line `def method = Resource.new(@client)`)
- `lib/crm/adapters/demo/resources/look_up_items/countries_resource.rb` — demo collection with 2 hardcoded stub entries
- `lib/crm/adapters/get_into_teaching/resources/look_up_items/countries_resource.rb` — GIT collection HTTP resource

**Test scenarios:**
- Happy path: generator produces correct `PickListItemsResource`, `CandidateResource`, and `InitialTeacherTrainingYearsResource` files under both adapter directories
- Happy path: generated demo collection resource's `all` returns 2 `Data.define(:id, :value)` stub entries (no `iso_code`)
- Happy path: generated GIT collection resource's `all` calls `get_request` with the path derived from the input segments
- Happy path: `CRM::Client`, `Demo::Client`, and `GIT::Client` each gain a `pick_list_items` method the first time that list_type appears
- Idempotency: second endpoint under the same list_type (`pick_list_items/candidate/preferred_education_phases`) does not add a duplicate `pick_list_items` method to any client
- Integration: `CRM::Client.new.pick_list_items.candidate.initial_teacher_training_years.all` returns an array (using the demo adapter) without raising

**Verification:**
- Running the generator and then starting a Rails console confirms the full fluent chain resolves without `NameError` or `NotImplementedError`
- All generated adapter spec files follow the delegation pattern from `spec/lib/crm/adapters/demo/resources/look_up_items_resource_spec.rb`

---

- [ ] **Unit 5: Controller, route, and request spec generation**

**Goal:** Wire the generator to produce the controller file, add the route to `config/routes.rb`, and create the request spec.

**Requirements:** R1, R2, R3, R5, R6

**Dependencies:** Unit 4

**Files:**
- Modify: `lib/generators/crm_endpoint/crm_endpoint_generator.rb`
- Test: `spec/generators/crm_endpoint_generator_spec.rb`

**Approach:**
- Controller: always create (leaf node); file path mirrors the input path under `app/controllers/api/`
- Routes: read current routes.rb content; determine which namespace blocks already exist using regex matching; insert the minimal required content (a `resources` line, a new `namespace` block, or a complete nested namespace block) using `insert_into_file` with a `:after` regex anchor on the innermost matching existing namespace declaration. If the regex anchor fails, append a clearly commented block inside the `api` namespace
- Request spec: always create under `spec/requests/api/<path>_spec.rb`

**Technical design:**

Route insertion cases (directional):
```
# Case 1: list_type namespace absent → insert inside api namespace:
namespace :<list_type> do
  [namespace :<category> do]   # depth-3 only
    resources :<collection>, only: :index
  [end]
end

# Case 2: list_type exists, category absent (depth-3) → insert inside list_type block:
namespace :<category> do
  resources :<collection>, only: :index
end

# Case 3: both list_type and category exist → insert inside category block:
resources :<collection>, only: :index
```

Anchor regex for case 1: match `namespace :api` block's first `do` line and insert after the next newline — or use the more reliable `:after => /namespace :api.*\n/`.

**Patterns to follow:**
- `app/controllers/api/lookup_items/countries_controller.rb` — controller file shape exactly
- `config/routes.rb` — existing indentation and namespace structure to maintain
- `spec/requests/api/lookup_items/countries_spec.rb` — request spec assertions (200, JSON content-type, `data` key)

**Test scenarios:**
- Happy path (depth-2): generator adds `resources :subjects, only: :index` inside the existing `namespace :lookup_items` block
- Happy path (depth-3, new list_type): generator adds a complete nested `namespace :pick_list_items { namespace :candidate { resources :initial_teacher_training_years, only: :index } }` block inside `namespace :api`
- Happy path (depth-3, list_type exists, category absent): generator adds `namespace :candidate { resources :preferred_education_phases }` inside the existing `namespace :pick_list_items` block
- Happy path (depth-3, both exist): generator adds only `resources :preferred_education_phases, only: :index` inside the existing `namespace :candidate` block
- Idempotency: running the generator twice for the same path does not add duplicate routes
- Integration: after running the generator, `rails routes` lists the new path

**Verification:**
- `rails routes | grep <collection>` returns the expected path and controller
- `GET /api/<path>` returns HTTP 200 with `{ "data": [...] }` (using the demo adapter default)
- Request spec passes with `bundle exec rspec spec/requests/api/<path>_spec.rb`

---

- [ ] **Unit 6: End-to-end generator test suite**

**Goal:** Add generator integration tests that run the generator in a temporary working directory and assert the complete file manifest is produced correctly for both depth-2 and depth-3 inputs, including idempotency.

**Requirements:** R1, R2, R3, R5, R6

**Dependencies:** Units 3, 4, 5

**Files:**
- Modify: `spec/generators/crm_endpoint_generator_spec.rb`

**Approach:**
- Use Rails generator testing helpers (`Rails::Generators::TestCase`) or RSpec with a temp directory fixture
- Two primary scenarios: one depth-2 run, one depth-3 run
- Assert file creation, content shape (module name, method name, class inheritance), and spec file presence
- Assert idempotency: run the generator for a sibling endpoint and verify the shared parent resource has exactly one occurrence of each method

**Patterns to follow:**
- Standard Rails generator test using `destination` and `prepare_destination` helpers from `Rails::Generators::TestCase`

**Test scenarios:**
- Happy path (depth-2): running `rails generate crm_endpoint lookup_items/new_subjects` produces all expected files; `spec/lib/crm/resources/look_up_items_resource_spec.rb` gains a test for `def new_subjects`
- Happy path (depth-3): running `rails generate crm_endpoint pick_list_items/candidate/initial_teacher_training_years` produces the full 26-file manifest listed in the technical design section
- Idempotency: after running both `pick_list_items/candidate/initial_teacher_training_years` and `pick_list_items/candidate/preferred_education_phases`, `pick_list_items_resource.rb` contains exactly one `def candidate` method
- Content assertion: generated demo collection resource contains `Data.define(:id, :value)` (not `iso_code`)
- Content assertion: generated GIT collection resource references `/api/pick_list_items/candidate/initial_teacher_training_years` as the HTTP path
- Content assertion: generated controller uses the correct 4-part fluent chain for depth-3

**Verification:**
- `bundle exec rspec spec/generators/` passes clean
- Running `bin/ci` passes after generating one depth-2 and one depth-3 endpoint

## System-Wide Impact

- **Interaction graph:** The generator modifies `lib/crm/client.rb`, both adapter clients, and `config/routes.rb`. Each modification is additive (new method or new route entry). No existing methods are changed.
- **Error propagation:** If route insertion fails (regex anchor not found), the generator should print a clear warning and append the route with a `# TODO: move into correct namespace` comment rather than raising — this keeps the generator usable even if the anchor logic has an edge case.
- **Zeitwerk:** Every new directory the generator creates under `lib/` or `app/` must use snake_case names that resolve cleanly without new acronym registrations. The generator should not create directories named with all-uppercase segments (e.g., `crm/`, `api/`) as those require inflection entries. Current acronyms (`CRM`, `API`) are already registered.
- **Unchanged invariants:** The existing `lookup_items` endpoints and their spec files are not touched by the generator.

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| `insert_into_file :before` anchor matches the wrong `end` in a multi-method file | Validate the anchor regex against the actual generated files with multiple methods during Unit 3 implementation; use the most specific anchor possible (e.g., matching `\n    end\n  end\nend\n` from the outermost module closure) |
| Routes regex anchor fails for an edge case routes.rb structure | Generator warns and appends with a TODO comment rather than raising; developer can relocate manually |
| Zeitwerk fails to load a generated file due to naming mismatch | Document `rails zeitwerk:check` as a required post-generation step in the generator's `say` output |
| Generated spec files for existing resources have a duplicate `describe` block | Generator checks for the describe block header before inserting, or appends as a separate `context` block |

## Sources & References

- **Origin document:** [docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md](docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md)
- Related plan: [docs/plans/2026-04-27-001-feat-demo-crm-adapter-countries-plan.md](docs/plans/2026-04-27-001-feat-demo-crm-adapter-countries-plan.md)
- Rails generators guide: https://guides.rubyonrails.org/generators.html
- Thor `insert_into_file`: https://www.rubydoc.info/github/wycats/thor/Thor/Actions#insert_into_file-instance_method
