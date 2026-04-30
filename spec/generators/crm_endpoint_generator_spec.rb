require "rails_helper"
require "rails/generators"
require "generators/crm_endpoint/crm_endpoint_generator"

RSpec.describe CrmEndpointGenerator do
  def generator(path)
    described_class.new([ path ], {}, destination_root: Rails.root.to_s)
  end

  describe "path parsing with a 1-level path" do
    subject(:gen) { generator("callback_booking_quotas") }

    it "sets depth to 1"          do expect(gen.depth).to eq(1) end
    it "sets list_type to nil"    do expect(gen.list_type).to be_nil end
    it "sets category to nil"     do expect(gen.category).to be_nil end
    it "sets collection"          do expect(gen.collection).to eq("callback_booking_quotas") end
    it "sets singular"            do expect(gen.singular).to eq("callback_booking_quota") end
  end

  describe "path parsing with a 2-level path" do
    subject(:gen) { generator("lookup_items/countries") }

    it "sets depth to 2"          do expect(gen.depth).to eq(2) end
    it "sets list_type"           do expect(gen.list_type).to eq("lookup_items") end
    it "sets category to nil"     do expect(gen.category).to be_nil end
    it "sets collection"          do expect(gen.collection).to eq("countries") end
    it "sets singular"            do expect(gen.singular).to eq("country") end
  end

  describe "path parsing with a 3-level path" do
    subject(:gen) { generator("pick_list_items/candidate/initial_teacher_training_years") }

    it "sets depth to 3"    do expect(gen.depth).to eq(3) end
    it "sets list_type"     do expect(gen.list_type).to eq("pick_list_items") end
    it "sets category"      do expect(gen.category).to eq("candidate") end
    it "sets collection"    do expect(gen.collection).to eq("initial_teacher_training_years") end
    it "sets singular"      do expect(gen.singular).to eq("initial_teacher_training_year") end
  end

  describe "#class_name_for" do
    subject(:gen) { generator("lookup_items/countries") }

    it "camelizes and appends Resource for a simple segment" do
      expect(gen.class_name_for("look_up_items")).to eq("LookUpItemsResource")
    end

    it "camelizes and appends Resource for a multi-word segment" do
      expect(gen.class_name_for("initial_teacher_training_years")).to eq("InitialTeacherTrainingYearsResource")
    end
  end

  describe "derived name helpers (depth-1)" do
    subject(:gen) { generator("callback_booking_quotas") }

    it { expect(gen.list_type_class).to be_nil }
    it { expect(gen.collection_class).to eq("CallbackBookingQuotasResource") }
    it { expect(gen.singular_class).to eq("CallbackBookingQuotaResource") }
    it { expect(gen.list_type_module).to be_nil }
    it { expect(gen.category_module).to be_nil }
    it { expect(gen.crm_resource_ns).to eq("CRM::Resources") }
    it { expect(gen.list_type_first_method).to be_nil }
    it { expect(gen.list_type_first_method_return).to be_nil }
    it { expect(gen.api_path).to eq("/api/callback_booking_quotas") }
    it { expect(gen.fluent_chain).to eq("crm_client.callback_booking_quotas.all") }
    it { expect(gen.controller_class).to eq("API::CallbackBookingQuotasController") }
    it { expect(gen.route_helper).to eq("api_callback_booking_quotas_path") }
  end

  describe "derived name helpers (depth-2)" do
    # Uses lookup_items/countries to verify depth-2 derivation.
    # Note: "lookup_items".camelize => "LookupItems" (no underscore between Look/Up).
    # Existing CRM resources use look_up_items (with underscore) — that's pre-generator legacy.
    subject(:gen) { generator("lookup_items/countries") }

    it { expect(gen.list_type_class).to eq("LookupItemsResource") }
    it { expect(gen.collection_class).to eq("CountriesResource") }
    it { expect(gen.singular_class).to eq("CountryResource") }
    it { expect(gen.list_type_module).to eq("LookupItems") }
    it { expect(gen.category_module).to be_nil }
    it { expect(gen.crm_resource_ns).to eq("CRM::Resources::LookupItems") }
    it { expect(gen.list_type_first_method).to eq("countries") }
    it { expect(gen.list_type_first_method_return).to eq("LookupItems::CountriesResource") }
    it { expect(gen.api_path).to eq("/api/lookup_items/countries") }
    it { expect(gen.fluent_chain).to eq("crm_client.lookup_items.countries.all") }
    it { expect(gen.controller_class).to eq("API::LookupItems::CountriesController") }
    it { expect(gen.route_helper).to eq("api_lookup_items_countries_path") }
  end

  describe "derived name helpers (depth-3)" do
    subject(:gen) { generator("pick_list_items/candidate/initial_teacher_training_years") }

    it { expect(gen.list_type_class).to eq("PickListItemsResource") }
    it { expect(gen.category_class).to eq("CandidateResource") }
    it { expect(gen.collection_class).to eq("InitialTeacherTrainingYearsResource") }
    it { expect(gen.singular_class).to eq("InitialTeacherTrainingYearResource") }
    it { expect(gen.list_type_module).to eq("PickListItems") }
    it { expect(gen.category_module).to eq("Candidate") }
    it { expect(gen.crm_resource_ns).to eq("CRM::Resources::PickListItems::Candidate") }
    it { expect(gen.list_type_first_method).to eq("candidate") }
    it { expect(gen.list_type_first_method_return).to eq("PickListItems::CandidateResource") }
    it { expect(gen.api_path).to eq("/api/pick_list_items/candidate/initial_teacher_training_years") }
    it { expect(gen.fluent_chain).to eq("crm_client.pick_list_items.candidate.initial_teacher_training_years.all") }
    it { expect(gen.controller_class).to eq("API::PickListItems::Candidate::InitialTeacherTrainingYearsController") }
    it { expect(gen.route_helper).to eq("api_pick_list_items_candidate_initial_teacher_training_years_path") }
  end

  describe "argument validation" do
    it "raises ArgumentError for an empty path" do
      expect { generator("") }
        .to raise_error(ArgumentError, /at least 1 segment/)
    end
  end

  # ── Integration tests ────────────────────────────────────────────────────────

  describe "integration: file generation" do
    let(:tmp_dir) { Dir.mktmpdir("crm_endpoint_generator_") }

    after { FileUtils.remove_entry(tmp_dir) }

    def run_generator(path)
      gen = CrmEndpointGenerator.new([ path ], {}, destination_root: tmp_dir)
      gen.invoke_all
      gen
    end

    def file_at(*parts)
      File.join(tmp_dir, *parts)
    end

    def content_of(*parts)
      File.read(file_at(*parts))
    end

    def exists?(*parts)
      File.exist?(file_at(*parts))
    end

    before do
      # Seed fixture files that the generator modifies (routes + clients)
      FileUtils.mkdir_p(File.join(tmp_dir, "config"))
      File.write(File.join(tmp_dir, "config/routes.rb"), <<~RUBY)
        Rails.application.routes.draw do
          namespace :api, defaults: { format: :json } do
            namespace :lookup_items do
              resources :countries, only: :index
            end
          end
        end
      RUBY

      FileUtils.mkdir_p(File.join(tmp_dir, "lib/crm"))
      File.write(File.join(tmp_dir, "lib/crm/client.rb"), <<~RUBY)
                module CRM
          class Client
            def initialize(adapter: CRM::Adapters::Demo::Client.new)
              @adapter = adapter
            end

            def lookup_items
              @adapter.lookup_items
            end
          end
        end
      RUBY

      FileUtils.mkdir_p(File.join(tmp_dir, "lib/crm/adapters/demo"))
      File.write(File.join(tmp_dir, "lib/crm/adapters/demo/client.rb"), <<~RUBY)
                module CRM
          module Adapters
            module Demo
              class Client
                def lookup_items
                  Resources::LookUpItemsResource.new
                end
              end
            end
          end
        end
      RUBY

      FileUtils.mkdir_p(File.join(tmp_dir, "lib/crm/adapters/get_into_teaching"))
      File.write(File.join(tmp_dir, "lib/crm/adapters/get_into_teaching/client.rb"), <<~RUBY)
                module CRM
          module Adapters
            module GetIntoTeaching
              class Client
                def lookup_items
                  Resources::LookUpItemsResource.new(self)
                end
              end
            end
          end
        end
      RUBY

      FileUtils.mkdir_p(File.join(tmp_dir, "spec/lib/crm/adapters/get_into_teaching"))
      File.write(File.join(tmp_dir, "spec/lib/crm/adapters/get_into_teaching/client_spec.rb"), <<~RUBY)
                require "rails_helper"

        RSpec.describe CRM::Adapters::GetIntoTeaching::Client do
          subject(:adapter) { described_class.new }

          describe "#lookup_items" do
            it "returns a GIT LookUpItemsResource" do
              expect(adapter.lookup_items).to be_a(CRM::Adapters::GetIntoTeaching::Resources::LookUpItemsResource)
            end
          end
        end
      RUBY
    end

    describe "depth-1 path: callback_booking_quotas" do
      before { run_generator("callback_booking_quotas") }

      it "creates the abstract collection resource directly under CRM::Resources (no module wrapper)" do
        path    = "lib/crm/resources/callback_booking_quotas_resource.rb"
        content = content_of(path)
        expect(exists?(path)).to be true
        expect(content).to include("class CallbackBookingQuotasResource")
        expect(content).to include("def all(*)")
        expect(content).to include("raise NotImplementedError")
        expect(content).not_to include("module LookupItems")
      end

      it "creates the value object directly under CRM::Resources" do
        expect(exists?("lib/crm/resources/callback_booking_quota_resource.rb")).to be true
        expect(content_of("lib/crm/resources/callback_booking_quota_resource.rb"))
          .to include("Data.define(:id, :value)")
      end

      it "creates the demo collection resource with stub entries" do
        path = "lib/crm/adapters/demo/resources/callback_booking_quotas_resource.rb"
        expect(exists?(path)).to be true
        expect(content_of(path)).to include("Example 1")
      end

      it "creates the GIT collection resource referencing the correct API path" do
        path = "lib/crm/adapters/get_into_teaching/resources/callback_booking_quotas_resource.rb"
        expect(exists?(path)).to be true
        expect(content_of(path)).to include("/api/callback_booking_quotas")
      end

      it "creates the controller" do
        expect(exists?("app/controllers/api/callback_booking_quotas_controller.rb")).to be true
      end

      it "adds the resource directly inside the api namespace (no extra namespace wrapper)" do
        routes = content_of("config/routes.rb")
        expect(routes).to include("resources :callback_booking_quotas, only: :index")
      end

      it "inserts a callback_booking_quotas method into CRM::Client" do
        expect(content_of("lib/crm/client.rb")).to include("def callback_booking_quotas")
      end

      it "inserts a callback_booking_quotas method into Demo::Client" do
        expect(content_of("lib/crm/adapters/demo/client.rb")).to include("def callback_booking_quotas")
      end

      it "inserts a callback_booking_quotas method into GIT::Client" do
        expect(content_of("lib/crm/adapters/get_into_teaching/client.rb")).to include("def callback_booking_quotas")
      end

      it "inserts a VCR describe block into the GIT client spec" do
        content = content_of("spec/lib/crm/adapters/get_into_teaching/client_spec.rb")
        expect(content).to include("describe \"#callback_booking_quotas\"")
        expect(content).to include("vcr: { cassette_name: \"CRM_Adapters_GetIntoTeaching_Client/callback_booking_quotas\" }")
        expect(content).to include("adapter.callback_booking_quotas.all")
      end

      it "creates spec files for all generated files" do
        expect(exists?("spec/lib/crm/resources/callback_booking_quotas_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/resources/callback_booking_quota_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/adapters/demo/resources/callback_booking_quotas_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/adapters/get_into_teaching/resources/callback_booking_quotas_resource_spec.rb")).to be true
        expect(exists?("spec/requests/api/callback_booking_quotas_spec.rb")).to be true
      end

      it "creates HTTP request files with correct content" do
        expect(exists?("docs/http_requests/api/callback_booking_quotas.http")).to be true
        expect(exists?("docs/http_requests/git_api/callback_booking_quotas.http")).to be true

        api_content = content_of("docs/http_requests/api/callback_booking_quotas.http")
        expect(api_content).to include("### Callback booking quotas")
        expect(api_content).to include("GET http://localhost:3000/api/callback_booking_quotas")
        expect(api_content).to include("?force_cache_miss=true")
      end
    end

    describe "depth-2 path: new_list_type/subjects" do
      before { run_generator("new_list_type/subjects") }

      it "creates the abstract list_type resource" do
        expect(exists?("lib/crm/resources/new_list_type_resource.rb")).to be true
        expect(content_of("lib/crm/resources/new_list_type_resource.rb"))
          .to include("def subjects(*) = raise NotImplementedError")
      end

      it "creates the abstract collection resource" do
        expect(exists?("lib/crm/resources/new_list_type/subjects_resource.rb")).to be true
        expect(content_of("lib/crm/resources/new_list_type/subjects_resource.rb"))
          .to include("def all(*)")
          .and include("raise NotImplementedError")
      end

      it "creates the value object with Data.define(:id, :value)" do
        expect(exists?("lib/crm/resources/new_list_type/subject_resource.rb")).to be true
        content = content_of("lib/crm/resources/new_list_type/subject_resource.rb")
        expect(content).to include("Data.define(:id, :value)")
        expect(content).not_to include("iso_code")
      end

      it "creates the demo collection resource with stub entries" do
        expect(exists?("lib/crm/adapters/demo/resources/new_list_type/subjects_resource.rb")).to be true
        expect(content_of("lib/crm/adapters/demo/resources/new_list_type/subjects_resource.rb"))
          .to include("Example 1")
      end

      it "creates the GIT collection resource referencing the correct API path" do
        expect(exists?("lib/crm/adapters/get_into_teaching/resources/new_list_type/subjects_resource.rb")).to be true
        expect(content_of("lib/crm/adapters/get_into_teaching/resources/new_list_type/subjects_resource.rb"))
          .to include("/api/new_list_type/subjects")
      end

      it "creates the controller" do
        expect(exists?("app/controllers/api/new_list_type/subjects_controller.rb")).to be true
      end

      it "adds the route inside the api namespace" do
        routes = content_of("config/routes.rb")
        expect(routes).to include("namespace :new_list_type do")
        expect(routes).to include("resources :subjects, only: :index")
      end

      it "inserts a list_type method into CRM::Client" do
        expect(content_of("lib/crm/client.rb")).to include("def new_list_type")
      end

      it "inserts a list_type method into Demo::Client" do
        expect(content_of("lib/crm/adapters/demo/client.rb")).to include("def new_list_type")
      end

      it "inserts a list_type method into GIT::Client" do
        expect(content_of("lib/crm/adapters/get_into_teaching/client.rb")).to include("def new_list_type")
      end

      it "inserts a VCR describe block into the GIT client spec" do
        content = content_of("spec/lib/crm/adapters/get_into_teaching/client_spec.rb")
        expect(content).to include("describe \"#new_list_type.subjects\"")
        expect(content).to include("vcr: { cassette_name: \"CRM_Adapters_GetIntoTeaching_Client/new_list_type/subjects\" }")
        expect(content).to include("adapter.new_list_type.subjects.all")
      end

      it "creates spec files for all generated files" do
        expect(exists?("spec/lib/crm/resources/new_list_type_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/resources/new_list_type/subjects_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/resources/new_list_type/subject_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/adapters/demo/resources/new_list_type/subjects_resource_spec.rb")).to be true
        expect(exists?("spec/lib/crm/adapters/get_into_teaching/resources/new_list_type/subjects_resource_spec.rb")).to be true
        expect(exists?("spec/requests/api/new_list_type/subjects_spec.rb")).to be true
      end

      it "creates HTTP request files with correct content" do
        expect(exists?("docs/http_requests/api/new_list_type/subjects.http")).to be true
        expect(exists?("docs/http_requests/git_api/new_list_type/subjects.http")).to be true

        api_content = content_of("docs/http_requests/api/new_list_type/subjects.http")
        expect(api_content).to include("### Subjects")
        expect(api_content).to include("GET http://localhost:3000/api/new_list_type/subjects")
        expect(api_content).to include("?force_cache_miss=true")

        git_content = content_of("docs/http_requests/git_api/new_list_type/subjects.http")
        expect(git_content).to include("GET {{apiUrl}}/api/new_list_type/subjects")
        expect(git_content).to include("Authorization: Bearer {{apiKey}}")
      end
    end

    describe "depth-3 path: pick_list_items/candidate/initial_teacher_training_years" do
      before { run_generator("pick_list_items/candidate/initial_teacher_training_years") }

      it "creates the abstract list_type resource with category method" do
        expect(exists?("lib/crm/resources/pick_list_items_resource.rb")).to be true
        expect(content_of("lib/crm/resources/pick_list_items_resource.rb"))
          .to include("def candidate(*) = raise NotImplementedError")
      end

      it "creates the abstract category resource with collection method" do
        expect(exists?("lib/crm/resources/pick_list_items/candidate_resource.rb")).to be true
        expect(content_of("lib/crm/resources/pick_list_items/candidate_resource.rb"))
          .to include("def initial_teacher_training_years(*) = raise NotImplementedError")
      end

      it "creates the abstract collection resource" do
        expect(exists?("lib/crm/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb")).to be true
      end

      it "creates the value object" do
        expect(exists?("lib/crm/resources/pick_list_items/candidate/initial_teacher_training_year_resource.rb")).to be true
        expect(content_of("lib/crm/resources/pick_list_items/candidate/initial_teacher_training_year_resource.rb"))
          .to include("Data.define(:id, :value)")
      end

      it "creates the demo adapter files" do
        expect(exists?("lib/crm/adapters/demo/resources/pick_list_items_resource.rb")).to be true
        expect(exists?("lib/crm/adapters/demo/resources/pick_list_items/candidate_resource.rb")).to be true
        expect(exists?("lib/crm/adapters/demo/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb")).to be true
      end

      it "creates the GIT adapter files with correct API path" do
        expect(exists?("lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb")).to be true
        expect(content_of("lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb"))
          .to include("/api/pick_list_items/candidate/initial_teacher_training_years")
      end

      it "generates a controller with the correct fluent chain" do
        expect(exists?("app/controllers/api/pick_list_items/candidate/initial_teacher_training_years_controller.rb")).to be true
        expect(content_of("app/controllers/api/pick_list_items/candidate/initial_teacher_training_years_controller.rb"))
          .to include("crm_client.pick_list_items.candidate.initial_teacher_training_years.all")
      end

      it "adds nested namespaces to routes" do
        routes = content_of("config/routes.rb")
        expect(routes).to include("namespace :pick_list_items do")
        expect(routes).to include("namespace :candidate do")
        expect(routes).to include("resources :initial_teacher_training_years, only: :index")
      end

      it "inserts methods into all three clients" do
        expect(content_of("lib/crm/client.rb")).to include("def pick_list_items")
        expect(content_of("lib/crm/adapters/demo/client.rb")).to include("def pick_list_items")
        expect(content_of("lib/crm/adapters/get_into_teaching/client.rb")).to include("def pick_list_items")
      end

      it "inserts a VCR describe block into the GIT client spec" do
        content = content_of("spec/lib/crm/adapters/get_into_teaching/client_spec.rb")
        expect(content).to include("describe \"#pick_list_items.candidate.initial_teacher_training_years\"")
        expect(content).to include("vcr: { cassette_name: \"CRM_Adapters_GetIntoTeaching_Client/pick_list_items/candidate/initial_teacher_training_years\" }")
        expect(content).to include("adapter.pick_list_items.candidate.initial_teacher_training_years.all")
      end

      it "creates spec files for all generated files" do
        [
          "spec/lib/crm/resources/pick_list_items_resource_spec.rb",
          "spec/lib/crm/resources/pick_list_items/candidate_resource_spec.rb",
          "spec/lib/crm/resources/pick_list_items/candidate/initial_teacher_training_years_resource_spec.rb",
          "spec/lib/crm/resources/pick_list_items/candidate/initial_teacher_training_year_resource_spec.rb",
          "spec/lib/crm/adapters/demo/resources/pick_list_items_resource_spec.rb",
          "spec/lib/crm/adapters/demo/resources/pick_list_items/candidate_resource_spec.rb",
          "spec/lib/crm/adapters/demo/resources/pick_list_items/candidate/initial_teacher_training_years_resource_spec.rb",
          "spec/lib/crm/adapters/get_into_teaching/resources/pick_list_items_resource_spec.rb",
          "spec/lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate_resource_spec.rb",
          "spec/lib/crm/adapters/get_into_teaching/resources/pick_list_items/candidate/initial_teacher_training_years_resource_spec.rb",
          "spec/requests/api/pick_list_items/candidate/initial_teacher_training_years_spec.rb",
        ].each { |path| expect(exists?(path)).to be(true), "expected #{path} to exist" }
      end

      it "creates HTTP request files with correct depth-3 title and path" do
        expect(exists?("docs/http_requests/api/pick_list_items/candidate/initial_teacher_training_years.http")).to be true
        expect(exists?("docs/http_requests/git_api/pick_list_items/candidate/initial_teacher_training_years.http")).to be true

        api_content = content_of("docs/http_requests/api/pick_list_items/candidate/initial_teacher_training_years.http")
        expect(api_content).to include("### Candidate Initial teacher training years")
        expect(api_content).to include("GET http://localhost:3000/api/pick_list_items/candidate/initial_teacher_training_years")
      end
    end

    describe "idempotency: second endpoint under same parent" do
      before do
        run_generator("pick_list_items/candidate/initial_teacher_training_years")
        run_generator("pick_list_items/candidate/preferred_education_phases")
      end

      it "does not duplicate the category method in the list_type resource" do
        content = content_of("lib/crm/resources/pick_list_items_resource.rb")
        expect(content.scan("def candidate").length).to eq(1)
      end

      it "adds the new collection method to the category resource" do
        content = content_of("lib/crm/resources/pick_list_items/candidate_resource.rb")
        expect(content).to include("def initial_teacher_training_years")
        expect(content).to include("def preferred_education_phases")
      end

      it "does not duplicate the list_type method in any client" do
        %w[
          lib/crm/client.rb
          lib/crm/adapters/demo/client.rb
          lib/crm/adapters/get_into_teaching/client.rb
        ].each do |path|
          content = content_of(path)
          expect(content.scan("def pick_list_items").length).to eq(1), "duplicate method in #{path}"
        end
      end

      it "creates separate collection resource files for each sibling" do
        expect(exists?("lib/crm/resources/pick_list_items/candidate/initial_teacher_training_years_resource.rb")).to be true
        expect(exists?("lib/crm/resources/pick_list_items/candidate/preferred_education_phases_resource.rb")).to be true
      end

      it "does not duplicate describe blocks in the list_type resource spec" do
        content = content_of("spec/lib/crm/resources/pick_list_items_resource_spec.rb")
        expect(content.scan("\"#candidate\"").length).to eq(1)
      end

      it "does not duplicate VCR describe blocks in the GIT client spec" do
        content = content_of("spec/lib/crm/adapters/get_into_teaching/client_spec.rb")
        expect(content.scan("\"#pick_list_items.candidate.initial_teacher_training_years\"").length).to eq(1)
        expect(content.scan("\"#pick_list_items.candidate.preferred_education_phases\"").length).to eq(1)
      end
    end

    describe "idempotency: running the exact same generator twice" do
      before do
        run_generator("new_list_type/subjects")
        run_generator("new_list_type/subjects")
      end

      it "does not duplicate the collection method in the list_type resource" do
        content = content_of("lib/crm/resources/new_list_type_resource.rb")
        expect(content.scan("def subjects").length).to eq(1)
      end

      it "does not duplicate routes" do
        content = content_of("config/routes.rb")
        expect(content.scan("resources :subjects, only: :index").length).to eq(1)
      end

      it "does not duplicate list_type methods in clients" do
        expect(content_of("lib/crm/client.rb").scan("def new_list_type").length).to eq(1)
      end
    end
  end
end
