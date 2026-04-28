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

    def depth        = segments.length
    def list_type    = segments[0]
    def category     = depth == 3 ? segments[1] : nil
    def collection   = segments[-1]
    def singular     = collection.singularize

    def class_name_for(segment)
      "#{segment.camelize}Resource"
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
