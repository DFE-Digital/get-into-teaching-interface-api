---
title: "CRM endpoint generator: automate Rails scaffolding across four adapter layers"
date: 2026-04-29
category: docs/solutions/developer-experience
module: CRM Adapter Generator
problem_type: developer_experience
component: tooling
severity: medium
applies_when:
  - adding any new CRM lookup endpoint to the Rails 8 JSON API
  - working within the 4-layer CRM adapter pattern (abstract base → demo → GetIntoTeaching → controller)
  - path follows a 2-level (list_type/collection) or 3-level (list_type/category/collection) structure
  - needing consistent scaffolding across abstract bases, demo stubs, HTTP resources, controllers, routes, and specs
related_components:
  - rails_controller
  - testing_framework
  - development_workflow
tags:
  - rails-generator
  - crm-adapter
  - code-generation
  - scaffolding
  - developer-experience
  - vcr-cassettes
  - zeitwerk
---

# CRM endpoint generator: automate Rails scaffolding across four adapter layers

## Context

Before this generator existed, adding a new CRM endpoint required manually creating or modifying up to 26 files across four architectural layers: abstract base resources, demo adapter resources, GetIntoTeaching (GIT) adapter resources, a controller, routes, and a full suite of spec files. Each layer has its own namespace conventions and indentation rules, and the insert-vs-create logic for shared parent resources had to be applied by hand. A single mistake — wrong indentation in a closing `end`, a missing `insert_into_file` anchor, or a misspelled class name — would produce a silent runtime error rather than a load-time failure. The cognitive overhead of remembering all four layers on every new endpoint was high, and the risk of drift between layers was real.

For the full architectural background, see: [`docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md`](../best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md).

## Guidance

### Running the generator

```bash
rails generate crm_endpoint <path>
```

Two path depths are supported:

```bash
rails generate crm_endpoint lookup_items/subjects                                       # depth-2
rails generate crm_endpoint pick_list_items/candidate/initial_teacher_training_years    # depth-3
```

After generation, always run:

```bash
bundle exec rails zeitwerk:check
```

### How names are derived

All class names, module names, file paths, and method chains are derived mechanically from the path argument:

```ruby
segments   = path.split("/")
# depth-3 example: ["pick_list_items", "candidate", "initial_teacher_training_years"]

list_type  = segments[0]              # "pick_list_items"
category   = segments[1]             # "candidate"          — nil for depth-2
collection = segments[-1]            # "initial_teacher_training_years"
singular   = collection.singularize  # "initial_teacher_training_year"

list_type_class  = list_type.camelize  + "Resource"  # "PickListItemsResource"
category_class   = category.camelize   + "Resource"  # "CandidateResource"
collection_class = collection.camelize + "Resource"  # "InitialTeacherTrainingYearsResource"
singular_class   = singular.camelize   + "Resource"  # "InitialTeacherTrainingYearResource"
```

All name helpers live in a `no_tasks` block inside the generator class so they are plain Ruby methods, not Thor actions.

### Create-or-insert pattern for shared parents

Leaf nodes (collection resource, value object, controller, request spec) are always created fresh. Shared parent resources use a create-or-insert pattern: the generator creates the file if absent, and inserts a method stub if the file is already present but the method is missing:

```ruby
def create_or_insert_resource(path, tmpl, method_name, snippet, anchor)
  if dest_exist?(path)
    insert_into_file(path, snippet, before: anchor) unless file_has_method?(path, method_name)
  else
    template tmpl, path
  end
end
```

`dest_exist?` and `file_has_method?` both resolve paths relative to `destination_root` — this makes the generator behave correctly both in production and in integration tests that use a temp directory:

```ruby
def dest_exist?(path)
  File.exist?(File.expand_path(path, destination_root))
end

def file_has_method?(path, method_name)
  dest_exist?(path) && File.read(File.expand_path(path, destination_root)).include?("def #{method_name}")
end
```

### Closing anchors and nesting depth

`insert_into_file` needs an exact string anchor to locate the insertion point. The anchor is the closing `end` sequence of the containing class. The number and indentation of `end` keywords is determined by module nesting depth:

| File | Nesting levels | Closing anchor |
|---|---|---|
| Abstract list-type resource | 3 (CRM > Resources > class) | `"\n    end\n  end\nend\n"` |
| Abstract category resource | 4 (CRM > Resources > ListType > class) | `"\n      end\n    end\n  end\nend\n"` |
| Demo/GIT list-type resource | 5 (CRM > Adapters > X > Resources > class) | `"\n        end\n      end\n    end\n  end\nend\n"` |
| Demo/GIT category resource | 6 (CRM > Adapters > X > Resources > ListType > class) | `"\n          end\n        end\n      end\n    end\n  end\nend\n"` |
| `CRM::Client` | 2 (CRM > class) | `"\n  end\nend\n"` |
| Demo/GIT `Client` | 4 (CRM > Adapters > X > class) | `"\n      end\n    end\n  end\nend\n"` |

Getting these wrong produces a Thor error at generation time (not a silent runtime error), so they are straightforward to verify.

### Route insertion — three cases

The generator inspects `config/routes.rb` and handles three states:

1. **List-type namespace absent** — inserts a complete nested block after `namespace :api`:

```ruby
namespace :pick_list_items do
  namespace :candidate do
    resources :initial_teacher_training_years, only: :index
  end
end
```

2. **List-type namespace present, category absent** (depth-3 only) — inserts the category block inside the existing list-type block.

3. **Both namespaces present** — inserts only the `resources` line inside the existing category block.

Depth-2 paths have only cases 1 and 3 (no category level).

### GIT client spec — intentionally failing VCR test

After generating all implementation files, the generator inserts a VCR-tagged `describe` block into `spec/lib/crm/adapters/get_into_teaching/client_spec.rb`. The `id` and `value` fields are set to `"TODO"` so the spec fails immediately, forcing the developer to record a real cassette before it can pass:

```ruby
describe "#pick_list_items.candidate.initial_teacher_training_years",
         vcr: { cassette_name: "CRM_Adapters_GetIntoTeaching_Client/initial_teacher_training_years" } do
  subject(:result) { adapter.pick_list_items.candidate.initial_teacher_training_years.all }

  it "returns InitialTeacherTrainingYearResource instances" do
    expect(result).to all(be_a(CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource))
  end

  it "deserializes the first entry correctly" do
    expect(result.first).to eq(
      CRM::Resources::PickListItems::Candidate::InitialTeacherTrainingYearResource.new(
        id: "TODO", value: "TODO"
      )
    )
  end
end
```

### Zeitwerk configuration (one-time setup)

`lib/generators` must be in the Zeitwerk ignore list in `config/application.rb`. Without this, Rails boot attempts to autoload the generator file as an application constant and fails:

```ruby
config.autoload_lib(ignore: %w[assets tasks generators])
```

This is already configured in the project; it only needs attention if the generator is moved or the project is forked.

## Why This Matters

The generator enforces the four-layer contract on every endpoint. A developer unfamiliar with the CRM adapter pattern can introduce a new lookup endpoint correctly on the first attempt. Structural mistakes — wrong module nesting, missing abstract method declarations, mismatched class names between layers — become impossible rather than merely unlikely.

The create-or-insert pattern means the generator is safe to run when some parent resources already exist. It adds only what is missing and leaves existing implementations untouched, making it viable for incremental adoption and for teams adding endpoints on parallel branches.

The intentionally failing VCR spec is a deliberate forcing function. It prevents the new endpoint from reaching a green test suite until a real cassette exists, which means a real API call has been made and deserialisation has been validated against actual CRM data.

## When to Apply

Use `rails generate crm_endpoint` whenever adding a new CRM lookup endpoint:

- Any new `GET /api/<list_type>/<collection>` or `GET /api/<list_type>/<category>/<collection>` endpoint returning a list of `{ id:, value: }` pairs from the CRM.
- When the endpoint maps to a CRM entity that does not yet have abstract base resources in `lib/crm/resources/`.
- When the endpoint maps to a CRM entity where some parent resources already exist (the generator safely inserts into them).

Do **not** use the generator for:

- Endpoints that return shapes other than `Array<Data.define(:id, :value)>` — the generator assumes this contract throughout all four layers.
- Non-lookup endpoints (write operations, parameterised fetches, composite resources).
- Cases where you need a custom demo stub beyond a hardcoded two-entry array — generate the files, then hand-edit the demo resource immediately after.

## Examples

### Depth-2: adding a simple lookup list

```bash
rails generate crm_endpoint lookup_items/subjects
```

Representative files created or modified:

```
create  lib/crm/resources/lookup_items_resource.rb              # (or insert def subjects)
create  lib/crm/resources/lookup_items/subjects_resource.rb
create  lib/crm/resources/lookup_items/subject_resource.rb      # value object
create  lib/crm/adapters/demo/resources/lookup_items_resource.rb  (or insert)
create  lib/crm/adapters/demo/resources/lookup_items/subjects_resource.rb
create  lib/crm/adapters/get_into_teaching/resources/lookup_items_resource.rb  (or insert)
create  lib/crm/adapters/get_into_teaching/resources/lookup_items/subjects_resource.rb
create  app/controllers/api/lookup_items/subjects_controller.rb
insert  config/routes.rb
insert  lib/crm/client.rb                                       # (if lookup_items method absent)
insert  lib/crm/adapters/demo/client.rb
insert  lib/crm/adapters/get_into_teaching/client.rb
create  spec/lib/crm/resources/lookup_items/subjects_resource_spec.rb
create  spec/lib/crm/adapters/demo/resources/lookup_items/subjects_resource_spec.rb
create  spec/lib/crm/adapters/get_into_teaching/resources/lookup_items/subjects_resource_spec.rb
create  spec/requests/api/lookup_items/subjects_spec.rb
insert  spec/lib/crm/adapters/get_into_teaching/client_spec.rb
```

### Depth-3: adding a categorised pick-list

```bash
rails generate crm_endpoint pick_list_items/candidate/initial_teacher_training_years
```

The category level (`candidate`) adds one extra resource file per layer plus one extra `namespace` level in routes. All other conventions are identical to depth-2.

### After generation: the one manual step

Record the VCR cassette to make the inserted client spec pass:

```bash
VCR_RECORD=new_episodes bundle exec rspec \
  spec/lib/crm/adapters/get_into_teaching/client_spec.rb \
  -e "initial_teacher_training_years"
```

Then replace the `"TODO"` values in the inserted `it "deserializes the first entry correctly"` block with the real `id` and `value` from the recorded cassette.

## Related

- [`docs/solutions/best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md`](../best-practices/crm-adapter-pattern-demo-phase-2026-04-27.md) — full architectural description of the 4-layer CRM adapter pattern; the generator automates the manual workflow documented in that doc's "Adding a new lookup resource" section.
- [`docs/plans/2026-04-28-002-feat-crm-endpoint-generator-plan.md`](../../plans/2026-04-28-002-feat-crm-endpoint-generator-plan.md) — implementation plan for the generator with full unit breakdown and decision rationale.
- Generator source: [`lib/generators/crm_endpoint/crm_endpoint_generator.rb`](../../../lib/generators/crm_endpoint/crm_endpoint_generator.rb)
- Generator specs: [`spec/generators/crm_endpoint_generator_spec.rb`](../../../spec/generators/crm_endpoint_generator_spec.rb)
