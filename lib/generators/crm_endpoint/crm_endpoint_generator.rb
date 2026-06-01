class CrmEndpointGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :endpoint_path, type: :string,
           desc: "Endpoint path with 1+ segments. " \
                 "Example: callback_booking_quotas, lookup_items/countries, or " \
                 "pick_list_items/candidate/initial_teacher_training_years"

  class_option :method, type: :string, default: "GET",
               desc: "HTTP method (GET, POST, PUT)"

  def initialize(args, opts, config)
    super
    @segments = parse_segments
  end

  def generate_endpoint
    generate_abstract_layer
    generate_demo_layer
    generate_git_layer
    generate_controller_layer
    generate_routes
    generate_request_spec
    generate_http_requests
    say "\n  Run: bundle exec rails zeitwerk:check", :green
  end

  no_tasks do
    attr_reader :segments

    def depth               = segments.length
    def intermediates       = segments[0..-2]
    def intermediate_modules = intermediates.map(&:camelize)
    def collection          = segments[-1]
    def singular            = collection.singularize

    # Backward-compat aliases retained for tests and route logic
    def list_type           = intermediates[0]
    def category            = intermediates[1]
    def list_type_module    = list_type&.camelize
    def category_module     = category&.camelize

    def class_name_for(segment)
      "#{segment.camelize}Resource"
    end

    def list_type_class   = list_type ? class_name_for(list_type) : nil
    def category_class    = category ? class_name_for(category) : nil
    def collection_class  = class_name_for(collection)
    def singular_class    = class_name_for(singular)

    # The method exposed on the top-level list_type resource (nil for depth 1)
    def list_type_first_method = segments[1]

    # The return type of list_type_first_method (nil for depth 1)
    def list_type_first_method_return
      return nil if depth < 2

      "#{intermediate_modules[0]}::#{segments[1].camelize}Resource"
    end

    def crm_resource_ns
      ([ "CRM", "Resources" ] + intermediate_modules).join("::")
    end

    def demo_collection_fqn
      ([ "CRM", "Adapters", "Demo", "Resources" ] + intermediate_modules + [ collection_class ]).join("::")
    end

    def git_collection_fqn
      ([ "CRM", "Adapters", "GetIntoTeaching", "Resources" ] + intermediate_modules + [ collection_class ]).join("::")
    end

    def api_path     = "/api/#{segments.join('/')}"
    def fluent_chain = "crm_client.#{segments.join('.')}.#{resource_method_name}"

    def human_title
      depth >= 3 ? "#{intermediates[-1].humanize} #{collection.humanize}" : collection.humanize
    end

    def controller_class = "API::#{segments.map(&:camelize).join('::')}Controller"
    def route_helper     = "api_#{segments.join('_')}_path"

    def http_method
      (options[:method] || "GET").upcase
    end

    def action_name
      case http_method
      when "GET"  then "index"
      when "POST" then "create"
      when "PUT"  then "update"
      else "index"
      end
    end

    def resource_method_name
      case http_method
      when "GET"  then "all"
      when "POST" then "create"
      when "PUT"  then "update"
      else "all"
      end
    end

    def resource_method_args
      case http_method
      when "GET"  then "**params"
      when "POST" then "**body"
      when "PUT"  then "id, **body"
      else "**params"
      end
    end

    def git_request_method
      case http_method
      when "GET"  then "get_request"
      when "POST" then "post_request"
      when "PUT"  then "put_request"
      end
    end

    def git_request_args
      case http_method
      when "GET"  then "params: params"
      when "POST" then "body: body"
      when "PUT"  then "body: body"
      end
    end

    def git_api_url
      if http_method == "PUT"
        "\"#{api_path}/\#{id}\""
      else
        api_path.inspect
      end
    end

    def git_response_method
      http_method == "GET" ? "response_to_collection" : "response_to_type"
    end

    def route_entry
      "resources :#{collection}, only: :#{action_name}"
    end

    def use_cache?
      http_method == "GET"
    end
  end

  private

  # ── Abstract base layer ──────────────────────────────────────────────────────

  def generate_abstract_layer
    intermediates.each_with_index { |_, i| generate_abstract_intermediate(i) }

    template "abstract_collection_resource.rb.tt",      collection_path("lib/crm/resources")
    template "value_object.rb.tt",                       singular_path("lib/crm/resources")
    template "spec_abstract_collection_resource.rb.tt", spec_collection_path("spec/lib/crm/resources")
    template "spec_value_object.rb.tt",                 spec_singular_path("spec/lib/crm/resources")
  end

  def generate_abstract_intermediate(i)
    seg      = intermediates[i]
    next_seg = intermediates[i + 1] || collection
    path      = "lib/crm/resources/#{intermediates[0..i].join('/')}_resource.rb"
    spec_path = "spec/lib/crm/resources/#{intermediates[0..i].join('/')}_resource_spec.rb"
    nesting   = i + 3  # CRM(1) + Resources(1) + i parent modules + class = i+3

    if dest_exist?(path)
      unless file_has_method?(path, next_seg)
        insert_into_file path,
          "\n\n#{"  " * nesting}def #{next_seg}(*) = raise NotImplementedError",
          before: closing_anchor(nesting)
      end
    else
      create_file path, abstract_intermediate_content(i, seg, next_seg)
    end

    if dest_exist?(spec_path)
      unless spec_has_describe?(spec_path, next_seg)
        insert_into_file spec_path,
          describe_block(next_seg,
            "    it \"raises NotImplementedError\" do\n" \
            "      expect { resource.#{next_seg} }.to raise_error(NotImplementedError)\n" \
            "    end\n"),
          before: "\nend\n"
      end
    else
      create_file spec_path, abstract_intermediate_spec_content(i, seg, next_seg)
    end
  end

  # ── Demo adapter layer ───────────────────────────────────────────────────────

  def generate_demo_layer
    intermediates.each_with_index { |_, i| generate_demo_intermediate(i) }

    template "demo_collection_resource.rb.tt",      collection_path("lib/crm/adapters/demo/resources")
    template "spec_demo_collection_resource.rb.tt", spec_collection_path("spec/lib/crm/adapters/demo/resources")
  end

  def generate_demo_intermediate(i)
    seg      = intermediates[i]
    next_seg = intermediates[i + 1] || collection
    path      = "lib/crm/adapters/demo/resources/#{intermediates[0..i].join('/')}_resource.rb"
    spec_path = "spec/lib/crm/adapters/demo/resources/#{intermediates[0..i].join('/')}_resource_spec.rb"
    # Return type is relative to CRM::Adapters::Demo::Resources (e.g. LookupItems::CountriesResource)
    ret_type  = "#{seg.camelize}::#{segments[i + 1].camelize}Resource"
    method_sp = "  " * (5 + i)
    body_sp   = "  " * (6 + i)
    nesting   = 5 + i  # CRM, Adapters, Demo, Resources, i parents, class

    if dest_exist?(path)
      unless file_has_method?(path, next_seg)
        insert_into_file path,
          "\n\n#{method_sp}def #{next_seg}\n#{body_sp}#{ret_type}.new\n#{method_sp}end",
          before: closing_anchor(nesting)
      end
    else
      create_file path, demo_intermediate_content(i, seg, next_seg, ret_type)
    end

    if dest_exist?(spec_path)
      unless spec_has_describe?(spec_path, next_seg)
        ret_fqn = ([ "CRM", "Adapters", "Demo", "Resources" ] +
                   intermediates[0..i].map(&:camelize) +
                   [ "#{segments[i + 1].camelize}Resource" ]).join("::")
        insert_into_file spec_path,
          describe_block(next_seg,
            "    it \"returns a Demo #{ret_type}\" do\n" \
            "      expect(resource.#{next_seg}).to be_a(#{ret_fqn})\n" \
            "    end\n"),
          before: "\nend\n"
      end
    else
      create_file spec_path, demo_intermediate_spec_content(i, seg, next_seg, ret_type)
    end
  end

  # ── GetIntoTeaching adapter layer ────────────────────────────────────────────

  def generate_git_layer
    intermediates.each_with_index { |_, i| generate_git_intermediate(i) }

    template "git_collection_resource.rb.tt",      collection_path("lib/crm/adapters/get_into_teaching/resources")
    template "spec_git_collection_resource.rb.tt", spec_collection_path("spec/lib/crm/adapters/get_into_teaching/resources")

    # The top-level client method name: for depth 1 it's the collection itself,
    # for depth >= 2 it's the first intermediate (list_type).
    client_name = depth >= 2 ? list_type : collection

    insert_client_method(
      "lib/crm/client.rb", client_name,
      "    def #{client_name}\n      @adapter.#{client_name}\n    end",
      "\n  end\nend\n"
    )

    demo_return = depth >= 2 ? "Resources::#{list_type_class}.new" : "Resources::#{collection_class}.new"
    insert_client_method(
      "lib/crm/adapters/demo/client.rb", client_name,
      "        def #{client_name}\n          #{demo_return}\n        end",
      "\n      end\n    end\n  end\nend\n"
    )

    git_return = depth >= 2 ? "Resources::#{list_type_class}.new(self)" : "Resources::#{collection_class}.new(self)"
    insert_client_method(
      "lib/crm/adapters/get_into_teaching/client.rb", client_name,
      "        def #{client_name}\n          #{git_return}\n        end",
      "\n      end\n    end\n  end\nend\n"
    )

    insert_git_client_spec
  end

  def generate_git_intermediate(i)
    seg      = intermediates[i]
    next_seg = intermediates[i + 1] || collection
    path      = "lib/crm/adapters/get_into_teaching/resources/#{intermediates[0..i].join('/')}_resource.rb"
    spec_path = "spec/lib/crm/adapters/get_into_teaching/resources/#{intermediates[0..i].join('/')}_resource_spec.rb"
    ret_type  = "#{seg.camelize}::#{segments[i + 1].camelize}Resource"
    method_sp = "  " * (5 + i)
    nesting   = 5 + i

    if dest_exist?(path)
      unless file_has_method?(path, next_seg)
        insert_into_file path,
          "\n\n#{method_sp}def #{next_seg} = #{ret_type}.new(@client)",
          before: closing_anchor(nesting)
      end
    else
      create_file path, git_intermediate_content(i, seg, next_seg, ret_type)
    end

    if dest_exist?(spec_path)
      unless spec_has_describe?(spec_path, next_seg)
        ret_fqn = ([ "CRM", "Adapters", "GetIntoTeaching", "Resources" ] +
                   intermediates[0..i].map(&:camelize) +
                   [ "#{segments[i + 1].camelize}Resource" ]).join("::")
        insert_into_file spec_path,
          describe_block(next_seg,
            "    it \"returns a GIT #{ret_type}\" do\n" \
            "      expect(resource.#{next_seg}).to be_a(#{ret_fqn})\n" \
            "    end\n"),
          before: "\nend\n"
      end
    else
      create_file spec_path, git_intermediate_spec_content(i, seg, next_seg, ret_type)
    end
  end

  # ── Controller layer ─────────────────────────────────────────────────────────

  def generate_controller_layer
    template "controller.rb.tt", "app/controllers/api/#{segments.join('/')}_controller.rb"
  end

  # ── Routes ───────────────────────────────────────────────────────────────────

  def generate_routes
    routes_path = "config/routes.rb"
    return unless dest_exist?(routes_path)

    content = dest_read(routes_path)
    return if content.include?(route_entry)

    if intermediates.empty?
      # depth 1: insert directly inside the api namespace
      insert_into_file routes_path,
        "    #{route_entry}\n",
        after: /namespace :api.*\n/
      return
    end

    # Count how many of the leading intermediate namespaces already exist
    existing_count = 0
    intermediates.each do |seg|
      break unless content.match?(/namespace :#{seg} do/)

      existing_count += 1
    end

    if existing_count == intermediates.length
      # All intermediate namespaces exist — add collection inside the innermost
      inner        = intermediates.last
      inner_indent = "  " * (intermediates.length + 2)
      insert_into_file routes_path,
        "#{inner_indent}#{route_entry}\n",
        after: /namespace :#{inner} do\n/
    elsif existing_count > 0
      # Some prefix namespaces exist — attach remaining chain after the last existing one
      anchor_seg = intermediates[existing_count - 1]
      new_segs   = intermediates[existing_count..]

      inner_content = "#{"  " * (intermediates.length + 2)}#{route_entry}\n"
      new_segs.reverse.each_with_index do |seg, ri|
        level         = existing_count + new_segs.length - 1 - ri
        indent        = "  " * (level + 2)
        inner_content = "#{indent}namespace :#{seg} do\n#{inner_content}#{indent}end\n"
      end

      insert_into_file routes_path, inner_content, after: /namespace :#{anchor_seg} do\n/
    else
      # No intermediate namespaces exist yet — build the full chain inside the api namespace
      inner_content = "#{"  " * (intermediates.length + 2)}#{route_entry}\n"
      intermediates.reverse.each_with_index do |seg, ri|
        level         = intermediates.length - 1 - ri
        indent        = "  " * (level + 2)
        inner_content = "#{indent}namespace :#{seg} do\n#{inner_content}#{indent}end\n"
      end

      insert_into_file routes_path, inner_content, after: /namespace :api.*\n/
    end
  end

  # ── Request spec ─────────────────────────────────────────────────────────────

  def generate_request_spec
    template "spec_request.rb.tt", "spec/requests/api/#{segments.join('/')}_spec.rb"
  end

  # ── HTTP request files ────────────────────────────────────────────────────────

  def generate_http_requests
    template "http_request_api.http.tt",     "docs/http_requests/api/#{segments.join('/')}.http"
    template "http_request_git_api.http.tt", "docs/http_requests/git_api/#{segments.join('/')}.http"
  end

  # ── Shared path helpers ──────────────────────────────────────────────────────

  def collection_path(base)
    [ base, *intermediates, "#{collection}_resource.rb" ].join("/")
  end

  def singular_path(base)
    [ base, *intermediates, "#{singular}_resource.rb" ].join("/")
  end

  def spec_collection_path(base)
    collection_path(base).sub("_resource.rb", "_resource_spec.rb")
  end

  def spec_singular_path(base)
    singular_path(base).sub("_resource.rb", "_resource_spec.rb")
  end

  # ── File access helpers ──────────────────────────────────────────────────────

  def dest_exist?(path)
    File.exist?(File.expand_path(path, destination_root))
  end

  def dest_read(path)
    File.read(File.expand_path(path, destination_root))
  end

  def file_has_method?(path, method_name)
    dest_exist?(path) && dest_read(path).include?("def #{method_name}")
  end

  def spec_has_describe?(path, method_name)
    dest_exist?(path) && dest_read(path).include?("\"##{method_name}\"")
  end

  def describe_block(method_name, body)
    "\n\n  describe \"##{method_name}\" do\n#{body}  end"
  end

  # Builds the closing-end sequence for a class nested `n` levels deep.
  # E.g. closing_anchor(3) => "\n    end\n  end\nend\n"
  def closing_anchor(total_nesting)
    "\n" + total_nesting.downto(1).map { |n| "  " * (n - 1) + "end" }.join("\n") + "\n"
  end

  def insert_client_method(path, method_name, snippet, anchor)
    return unless dest_exist?(path)
    return if file_has_method?(path, method_name)

    insert_into_file path, "\n\n#{snippet}", before: anchor
  end

  def insert_git_client_spec
    spec_path    = "spec/lib/crm/adapters/get_into_teaching/client_spec.rb"
    describe_key = "\"##{segments.join('.')}\""
    return unless dest_exist?(spec_path)
    return if dest_read(spec_path).include?(describe_key)

    cassette = "CRM_Adapters_GetIntoTeaching_Client/#{segments.join('/')}"
    chain    = "adapter.#{segments.join('.')}.#{resource_method_name}"
    fqn      = "#{crm_resource_ns}::#{singular_class}"

    snippet = if http_method == "GET"
      "\n\n  describe \"##{segments.join('.')}\", " \
        "vcr: { cassette_name: \"#{cassette}\" } do\n" \
        "    subject(:result) { #{chain} }\n\n" \
        "    it \"returns #{singular_class} instances\" do\n" \
        "      expect(result).to all(be_a(#{fqn}))\n" \
        "    end\n\n" \
        "    it \"deserializes the first entry correctly\" do\n" \
        "      expect(result.first).to eq(\n" \
        "        #{fqn}.new(\n" \
        "          id: \"TODO\",\n" \
        "          value: \"TODO\",\n" \
        "        )\n" \
        "      )\n" \
        "    end\n" \
        "  end"
    else
      "\n\n  describe \"##{segments.join('.')}\", " \
        "vcr: { cassette_name: \"#{cassette}\" } do\n" \
        "    subject(:result) { #{chain} }\n\n" \
        "    it \"returns a #{singular_class} instance\" do\n" \
        "      expect(result).to be_a(#{fqn})\n" \
        "    end\n\n" \
        "    it \"deserializes the response correctly\" do\n" \
        "      expect(result).to eq(\n" \
        "        #{fqn}.new(\n" \
        "          id: \"TODO\",\n" \
        "          value: \"TODO\",\n" \
        "        )\n" \
        "      )\n" \
        "    end\n" \
        "  end"
    end

    insert_into_file spec_path, snippet, before: "\nend\n"
  end

  # ── Content builders for intermediate resources ──────────────────────────────
  # These replace template files for the chain of intermediate namespace resources,
  # since their structure varies with arbitrary nesting depth.

  def abstract_intermediate_content(i, seg, next_seg)
    parents = intermediates[0...i].map(&:camelize)
    klass   = "#{seg.camelize}Resource"
    ki      = i + 2  # indent level for class (2 outer modules + i parent modules)
    mi      = i + 3  # indent level for method

    lines = [ "module CRM", "  module Resources" ]
    parents.each_with_index { |mod, j| lines << "#{"  " * (j + 2)}module #{mod}" }
    lines << "#{"  " * ki}class #{klass}"
    lines << "#{"  " * mi}def #{next_seg}(*) = raise NotImplementedError"
    lines << "#{"  " * ki}end"
    parents.length.downto(1) { |k| lines << "#{"  " * (k + 1)}end" }
    lines << "  end"
    lines << "end"
    lines.join("\n") + "\n"
  end

  def abstract_intermediate_spec_content(i, seg, next_seg)
    parents = intermediates[0...i].map(&:camelize)
    klass   = "#{seg.camelize}Resource"
    fqn     = ([ "CRM", "Resources" ] + parents + [ klass ]).join("::")

    <<~RUBY
      require "rails_helper"

      RSpec.describe #{fqn} do
        subject(:resource) { described_class.new }

        describe "##{next_seg}" do
          it "raises NotImplementedError" do
            expect { resource.#{next_seg} }.to raise_error(NotImplementedError)
          end
        end
      end
    RUBY
  end

  def demo_intermediate_content(i, seg, next_seg, ret_type)
    parents   = intermediates[0...i].map(&:camelize)
    klass     = "#{seg.camelize}Resource"
    parent_ns = ([ "CRM", "Resources" ] + parents + [ klass ]).join("::")
    base      = 4  # CRM, Adapters, Demo, Resources
    ki        = base + i
    mi        = base + i + 1
    bi        = base + i + 2

    lines = [ "module CRM", "  module Adapters", "    module Demo", "      module Resources" ]
    parents.each_with_index { |mod, j| lines << "#{"  " * (base + j)}module #{mod}" }
    lines << "#{"  " * ki}class #{klass} < #{parent_ns}"
    lines << "#{"  " * mi}def #{next_seg}"
    lines << "#{"  " * bi}#{ret_type}.new"
    lines << "#{"  " * mi}end"
    lines << "#{"  " * ki}end"
    parents.length.downto(1) { |k| lines << "#{"  " * (base + k - 1)}end" }
    lines << "      end"
    lines << "    end"
    lines << "  end"
    lines << "end"
    lines.join("\n") + "\n"
  end

  def demo_intermediate_spec_content(i, seg, next_seg, ret_type)
    parents = intermediates[0...i].map(&:camelize)
    klass   = "#{seg.camelize}Resource"
    fqn     = ([ "CRM", "Adapters", "Demo", "Resources" ] + parents + [ klass ]).join("::")
    ret_fqn = ([ "CRM", "Adapters", "Demo", "Resources" ] +
               intermediates[0..i].map(&:camelize) +
               [ "#{segments[i + 1].camelize}Resource" ]).join("::")

    <<~RUBY
      require "rails_helper"

      RSpec.describe #{fqn} do
        subject(:resource) { described_class.new }

        describe "##{next_seg}" do
          it "returns a Demo #{ret_type}" do
            expect(resource.#{next_seg}).to be_a(#{ret_fqn})
          end
        end
      end
    RUBY
  end

  def git_intermediate_content(i, seg, next_seg, ret_type)
    parents   = intermediates[0...i].map(&:camelize)
    klass     = "#{seg.camelize}Resource"
    parent_ns = ([ "CRM", "Resources" ] + parents + [ klass ]).join("::")
    base      = 4
    ki        = base + i
    mi        = base + i + 1

    lines = [ "module CRM", "  module Adapters", "    module GetIntoTeaching", "      module Resources" ]
    parents.each_with_index { |mod, j| lines << "#{"  " * (base + j)}module #{mod}" }
    lines << "#{"  " * ki}class #{klass} < #{parent_ns}"
    lines << "#{"  " * mi}def initialize(client)"
    lines << "#{"  " * (mi + 1)}@client = client"
    lines << "#{"  " * mi}end"
    lines << ""
    lines << "#{"  " * mi}def #{next_seg} = #{ret_type}.new(@client)"
    lines << "#{"  " * ki}end"
    parents.length.downto(1) { |k| lines << "#{"  " * (base + k - 1)}end" }
    lines << "      end"
    lines << "    end"
    lines << "  end"
    lines << "end"
    lines.join("\n") + "\n"
  end

  def git_intermediate_spec_content(i, seg, next_seg, ret_type)
    parents = intermediates[0...i].map(&:camelize)
    klass   = "#{seg.camelize}Resource"
    fqn     = ([ "CRM", "Adapters", "GetIntoTeaching", "Resources" ] + parents + [ klass ]).join("::")
    ret_fqn = ([ "CRM", "Adapters", "GetIntoTeaching", "Resources" ] +
               intermediates[0..i].map(&:camelize) +
               [ "#{segments[i + 1].camelize}Resource" ]).join("::")

    <<~RUBY
      require "rails_helper"

      RSpec.describe #{fqn} do
        let(:client) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }

        subject(:resource) { described_class.new(client) }

        describe "##{next_seg}" do
          it "returns a GIT #{ret_type}" do
            expect(resource.#{next_seg}).to be_a(#{ret_fqn})
          end
        end
      end
    RUBY
  end

  def parse_segments
    segs = endpoint_path.split("/").map(&:strip).reject(&:empty?)
    if segs.empty?
      raise ArgumentError,
            "path must have at least 1 segment, got empty path #{endpoint_path.inspect}. " \
            "Example: rails generate crm_endpoint callback_booking_quotas"
    end

    segs
  end
end
