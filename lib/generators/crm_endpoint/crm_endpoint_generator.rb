# frozen_string_literal: true

class CrmEndpointGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :endpoint_path, type: :string,
           desc: "Endpoint path: 2 segments (list_type/collection) or " \
                 "3 segments (list_type/category/collection). " \
                 "Example: lookup_items/countries or pick_list_items/candidate/initial_teacher_training_years"

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
    say "\n  Run: bundle exec rails zeitwerk:check", :green
  end

  no_tasks do
    attr_reader :segments

    def depth        = segments.length
    def list_type    = segments[0]
    def category     = depth == 3 ? segments[1] : nil
    def collection   = segments[-1]
    def singular     = collection.singularize

    def class_name_for(segment)
      "#{segment.camelize}Resource"
    end

    def list_type_class    = class_name_for(list_type)
    def category_class     = category ? class_name_for(category) : nil
    def collection_class   = class_name_for(collection)
    def singular_class     = class_name_for(singular)
    def list_type_module   = list_type.camelize
    def category_module    = category&.camelize

    def crm_resource_ns
      depth == 3 ? "CRM::Resources::#{list_type_module}::#{category_module}" : "CRM::Resources::#{list_type_module}"
    end

    def list_type_first_method
      depth == 3 ? category : collection
    end

    def list_type_first_method_return
      depth == 3 ? "#{list_type_module}::#{category_class}" : "#{list_type_module}::#{collection_class}"
    end

    def api_path     = "/api/#{segments.join('/')}"
    def fluent_chain = "crm_client.#{segments.join('.')}.all"

    def controller_class = "API::#{segments.map(&:camelize).join('::')}Controller"
    def route_helper     = "api_#{segments.join('_')}_path"

    def demo_collection_fqn
      if depth == 3
        "CRM::Adapters::Demo::Resources::#{list_type_module}::#{category_module}::#{collection_class}"
      else
        "CRM::Adapters::Demo::Resources::#{list_type_module}::#{collection_class}"
      end
    end

    def git_collection_fqn
      if depth == 3
        "CRM::Adapters::GetIntoTeaching::Resources::#{list_type_module}::#{category_module}::#{collection_class}"
      else
        "CRM::Adapters::GetIntoTeaching::Resources::#{list_type_module}::#{collection_class}"
      end
    end
  end

  private

  # ── Abstract base layer ──────────────────────────────────────────────────────

  def generate_abstract_layer
    abs_lt_path = "lib/crm/resources/#{list_type}_resource.rb"
    create_or_insert_resource(
      abs_lt_path, "abstract_list_type_resource.rb.tt",
      list_type_first_method,
      "\n\n      def #{list_type_first_method}(*) = raise NotImplementedError",
      "\n    end\n  end\nend\n"
    )

    spec_lt_path = "spec/lib/crm/resources/#{list_type}_resource_spec.rb"
    create_or_insert_spec(
      spec_lt_path, "spec_abstract_list_type_resource.rb.tt",
      list_type_first_method,
      describe_block(list_type_first_method,
        "    it \"raises NotImplementedError\" do\n" \
        "      expect { resource.#{list_type_first_method} }.to raise_error(NotImplementedError)\n" \
        "    end\n")
    )

    if depth == 3
      abs_cat_path = "lib/crm/resources/#{list_type}/#{category}_resource.rb"
      create_or_insert_resource(
        abs_cat_path, "abstract_category_resource.rb.tt",
        collection,
        "\n\n        def #{collection}(*) = raise NotImplementedError",
        "\n      end\n    end\n  end\nend\n"
      )

      spec_cat_path = "spec/lib/crm/resources/#{list_type}/#{category}_resource_spec.rb"
      create_or_insert_spec(
        spec_cat_path, "spec_abstract_category_resource.rb.tt",
        collection,
        describe_block(collection,
          "    it \"raises NotImplementedError\" do\n" \
          "      expect { resource.#{collection} }.to raise_error(NotImplementedError)\n" \
          "    end\n")
      )
    end

    template "abstract_collection_resource.rb.tt",      collection_path("lib/crm/resources")
    template "value_object.rb.tt",                       singular_path("lib/crm/resources")
    template "spec_abstract_collection_resource.rb.tt", spec_collection_path("spec/lib/crm/resources")
    template "spec_value_object.rb.tt",                 spec_singular_path("spec/lib/crm/resources")
  end

  # ── Demo adapter layer ───────────────────────────────────────────────────────

  def generate_demo_layer
    demo_lt_path = "lib/crm/adapters/demo/resources/#{list_type}_resource.rb"
    create_or_insert_resource(
      demo_lt_path, "demo_list_type_resource.rb.tt",
      list_type_first_method,
      "\n\n          def #{list_type_first_method}\n            #{list_type_first_method_return}.new\n          end",
      "\n        end\n      end\n    end\n  end\nend\n"
    )

    spec_demo_lt_path = "spec/lib/crm/adapters/demo/resources/#{list_type}_resource_spec.rb"
    create_or_insert_spec(
      spec_demo_lt_path, "spec_demo_list_type_resource.rb.tt",
      list_type_first_method,
      describe_block(list_type_first_method,
        "    it \"returns a Demo #{list_type_first_method_return}\" do\n" \
        "      expect(resource.#{list_type_first_method}).to be_a(CRM::Adapters::Demo::Resources::#{list_type_first_method_return})\n" \
        "    end\n")
    )

    if depth == 3
      demo_cat_path = "lib/crm/adapters/demo/resources/#{list_type}/#{category}_resource.rb"
      create_or_insert_resource(
        demo_cat_path, "demo_category_resource.rb.tt",
        collection,
        "\n\n            def #{collection}\n              #{category_module}::#{collection_class}.new\n            end",
        "\n          end\n        end\n      end\n    end\n  end\nend\n"
      )

      spec_demo_cat_path = "spec/lib/crm/adapters/demo/resources/#{list_type}/#{category}_resource_spec.rb"
      create_or_insert_spec(
        spec_demo_cat_path, "spec_demo_category_resource.rb.tt",
        collection,
        describe_block(collection,
          "    it \"returns a Demo #{list_type_module}::#{category_module}::#{collection_class}\" do\n" \
          "      expect(resource.#{collection}).to be_a(CRM::Adapters::Demo::Resources::#{list_type_module}::#{category_module}::#{collection_class})\n" \
          "    end\n")
      )
    end

    template "demo_collection_resource.rb.tt",      collection_path("lib/crm/adapters/demo/resources")
    template "spec_demo_collection_resource.rb.tt", spec_collection_path("spec/lib/crm/adapters/demo/resources")
  end

  # ── GetIntoTeaching adapter layer ────────────────────────────────────────────

  def generate_git_layer
    git_lt_path = "lib/crm/adapters/get_into_teaching/resources/#{list_type}_resource.rb"
    create_or_insert_resource(
      git_lt_path, "git_list_type_resource.rb.tt",
      list_type_first_method,
      "\n\n          def #{list_type_first_method} = #{list_type_first_method_return}.new(@client)",
      "\n        end\n      end\n    end\n  end\nend\n"
    )

    spec_git_lt_path = "spec/lib/crm/adapters/get_into_teaching/resources/#{list_type}_resource_spec.rb"
    create_or_insert_spec(
      spec_git_lt_path, "spec_git_list_type_resource.rb.tt",
      list_type_first_method,
      describe_block(list_type_first_method,
        "    it \"returns a GIT #{list_type_first_method_return}\" do\n" \
        "      expect(resource.#{list_type_first_method}).to be_a(CRM::Adapters::GetIntoTeaching::Resources::#{list_type_first_method_return})\n" \
        "    end\n")
    )

    if depth == 3
      git_cat_path = "lib/crm/adapters/get_into_teaching/resources/#{list_type}/#{category}_resource.rb"
      create_or_insert_resource(
        git_cat_path, "git_category_resource.rb.tt",
        collection,
        "\n\n            def #{collection} = #{category_module}::#{collection_class}.new(@client)",
        "\n          end\n        end\n      end\n    end\n  end\nend\n"
      )

      spec_git_cat_path = "spec/lib/crm/adapters/get_into_teaching/resources/#{list_type}/#{category}_resource_spec.rb"
      create_or_insert_spec(
        spec_git_cat_path, "spec_git_category_resource.rb.tt",
        collection,
        describe_block(collection,
          "    it \"returns a GIT #{list_type_module}::#{category_module}::#{collection_class}\" do\n" \
          "      expect(resource.#{collection}).to be_a(CRM::Adapters::GetIntoTeaching::Resources::#{list_type_module}::#{category_module}::#{collection_class})\n" \
          "    end\n")
      )
    end

    template "git_collection_resource.rb.tt",      collection_path("lib/crm/adapters/get_into_teaching/resources")
    template "spec_git_collection_resource.rb.tt", spec_collection_path("spec/lib/crm/adapters/get_into_teaching/resources")

    insert_client_method(
      "lib/crm/client.rb", list_type,
      "    def #{list_type}\n      @adapter.#{list_type}\n    end",
      "\n  end\nend\n"
    )
    insert_client_method(
      "lib/crm/adapters/demo/client.rb", list_type,
      "        def #{list_type}\n          Resources::#{list_type_class}.new\n        end",
      "\n      end\n    end\n  end\nend\n"
    )
    insert_client_method(
      "lib/crm/adapters/get_into_teaching/client.rb", list_type,
      "        def #{list_type}\n          Resources::#{list_type_class}.new(self)\n        end",
      "\n      end\n    end\n  end\nend\n"
    )

    insert_git_client_spec
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
    return if content.include?("resources :#{collection}, only: :index")

    if depth == 2
      if content.match?(/namespace :#{list_type} do/)
        insert_into_file routes_path,
          "      resources :#{collection}, only: :index\n",
          after: /namespace :#{list_type} do\n/
      else
        insert_into_file routes_path,
          "\n    namespace :#{list_type} do\n      resources :#{collection}, only: :index\n    end",
          after: /namespace :api.*\n/
      end
    else
      lt_exists  = content.match?(/namespace :#{list_type} do/)
      cat_exists = content.match?(/namespace :#{category} do/)

      if lt_exists && cat_exists
        insert_into_file routes_path,
          "        resources :#{collection}, only: :index\n",
          after: /namespace :#{category} do\n/
      elsif lt_exists
        insert_into_file routes_path,
          "      namespace :#{category} do\n        resources :#{collection}, only: :index\n      end\n",
          after: /namespace :#{list_type} do\n/
      else
        insert_into_file routes_path,
          "\n    namespace :#{list_type} do\n" \
          "      namespace :#{category} do\n" \
          "        resources :#{collection}, only: :index\n" \
          "      end\n    end",
          after: /namespace :api.*\n/
      end
    end
  end

  # ── Request spec ─────────────────────────────────────────────────────────────

  def generate_request_spec
    template "spec_request.rb.tt", "spec/requests/api/#{segments.join('/')}_spec.rb"
  end

  # ── Shared helpers ───────────────────────────────────────────────────────────

  def collection_path(base)
    depth == 3 ? "#{base}/#{list_type}/#{category}/#{collection}_resource.rb"
               : "#{base}/#{list_type}/#{collection}_resource.rb"
  end

  def singular_path(base)
    depth == 3 ? "#{base}/#{list_type}/#{category}/#{singular}_resource.rb"
               : "#{base}/#{list_type}/#{singular}_resource.rb"
  end

  def spec_collection_path(base)
    collection_path(base).sub("_resource.rb", "_resource_spec.rb")
  end

  def spec_singular_path(base)
    singular_path(base).sub("_resource.rb", "_resource_spec.rb")
  end

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

  def create_or_insert_resource(path, tmpl, method_name, snippet, anchor)
    if dest_exist?(path)
      insert_into_file(path, snippet, before: anchor) unless file_has_method?(path, method_name)
    else
      template tmpl, path
    end
  end

  def create_or_insert_spec(path, tmpl, method_name, snippet)
    if dest_exist?(path)
      insert_into_file(path, snippet, before: "\nend\n") unless spec_has_describe?(path, method_name)
    else
      template tmpl, path
    end
  end

  def insert_git_client_spec
    spec_path    = "spec/lib/crm/adapters/get_into_teaching/client_spec.rb"
    describe_key = "\"##{segments.join('.')}\""
    return unless dest_exist?(spec_path)
    return if dest_read(spec_path).include?(describe_key)

    cassette = "CRM_Adapters_GetIntoTeaching_Client/#{collection}"
    chain    = "adapter.#{segments.join('.')}.all"
    fqn      = "#{crm_resource_ns}::#{singular_class}"

    snippet = "\n\n  describe \"##{segments.join('.')}\", " \
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

    insert_into_file spec_path, snippet, before: "\nend\n"
  end

  def insert_client_method(path, method_name, snippet, anchor)
    return unless dest_exist?(path)
    return if file_has_method?(path, method_name)

    insert_into_file path, "\n\n#{snippet}", before: anchor
  end

  def parse_segments
    segs = endpoint_path.split("/").map(&:strip).reject(&:empty?)
    unless segs.length.between?(2, 3)
      raise ArgumentError,
            "path must have 2 or 3 segments, got #{segs.length} in #{endpoint_path.inspect}. " \
            "Example: rails generate crm_endpoint list_type/collection"
    end

    segs
  end
end
