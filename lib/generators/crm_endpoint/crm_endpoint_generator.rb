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
    say "TODO: file generation implemented in subsequent units", :yellow
  end

  no_tasks do
    attr_reader :segments

    # --- Basic name derivation ---

    def depth        = segments.length
    def list_type    = segments[0]
    def category     = depth == 3 ? segments[1] : nil
    def collection   = segments[-1]
    def singular     = collection.singularize

    def class_name_for(segment)
      "#{segment.camelize}Resource"
    end

    # --- Module name helpers ---

    def list_type_class    = class_name_for(list_type)
    def category_class     = category ? class_name_for(category) : nil
    def collection_class   = class_name_for(collection)
    def singular_class     = class_name_for(singular)
    def list_type_module   = list_type.camelize
    def category_module    = category&.camelize

    # --- Namespace helpers ---

    # Full CRM::Resources module path for the collection (no trailing class name)
    def crm_resource_ns
      depth == 3 ? "CRM::Resources::#{list_type_module}::#{category_module}" : "CRM::Resources::#{list_type_module}"
    end

    # --- First-method helpers (what list_type_resource delegates to) ---

    # Method name on the list_type resource: category name (depth-3) or collection name (depth-2)
    def list_type_first_method
      depth == 3 ? category : collection
    end

    # Class returned by that method, relative to the Resources module
    def list_type_first_method_return
      depth == 3 ? "#{list_type_module}::#{category_class}" : "#{list_type_module}::#{collection_class}"
    end

    # --- API / chain helpers ---

    def api_path     = "/api/#{segments.join('/')}"
    def fluent_chain = "CRM::Client.new.#{segments.join('.')}.all"

    # --- Controller / route helpers ---

    def controller_class = "API::#{segments.map(&:camelize).join('::')}Controller"
    def route_helper     = "api_#{segments.join('_')}_path"

    # --- Fully-qualified class names for specs ---

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
