require "rails_helper"

RSpec.describe CRM::Client do
  describe "#lookup_items" do
    context "with the default adapter" do
      it "returns a Demo LookUpItemsResource" do
        expect(described_class.new(adapter: CRM::Adapters::Demo::Client.new).lookup_items).to be_a(CRM::Adapters::Demo::Resources::LookUpItemsResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::Demo::Client) }
      let(:lookup_items_resource) { instance_double(CRM::Adapters::Demo::Resources::LookUpItemsResource) }

      before { allow(adapter).to receive(:lookup_items).and_return(lookup_items_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).lookup_items

        expect(result).to eq(lookup_items_resource)
      end
    end
  end

  describe "#pick_list_items" do
    context "with the default adapter" do
      it "returns a Demo PickListItemsResource" do
        expect(described_class.new(adapter: CRM::Adapters::Demo::Client.new).pick_list_items).to be_a(CRM::Adapters::Demo::Resources::PickListItemsResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::Demo::Client) }
      let(:pick_list_items_resource) { instance_double(CRM::Adapters::Demo::Resources::PickListItemsResource) }

      before { allow(adapter).to receive(:pick_list_items).and_return(pick_list_items_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).pick_list_items

        expect(result).to eq(pick_list_items_resource)
      end
    end
  end

  describe "#callback_booking_quotas" do
    context "with the default adapter" do
      it "returns a Demo CallbackBookQuotasResource" do
        expect(described_class.new(adapter: CRM::Adapters::Demo::Client.new).callback_booking_quotas).to be_a(CRM::Adapters::Demo::Resources::CallbackBookingQuotasResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::Demo::Client) }
      let(:callback_booking_quotas_resource) { instance_double(CRM::Adapters::Demo::Resources::CallbackBookingQuotasResource) }

      before { allow(adapter).to receive(:callback_booking_quotas).and_return(callback_booking_quotas_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).callback_booking_quotas

        expect(result).to eq(callback_booking_quotas_resource)
      end
    end
  end

  describe "#privacy_policies" do
    context "with the default adapter" do
      it "returns a Demo PrivacyPoliciesResource" do
        expect(described_class.new(adapter: CRM::Adapters::Demo::Client.new).privacy_policies).to be_a(CRM::Adapters::Demo::Resources::PrivacyPoliciesResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::Demo::Client) }
      let(:privacy_policies_resource) { instance_double(CRM::Adapters::Demo::Resources::PrivacyPoliciesResource) }

      before { allow(adapter).to receive(:privacy_policies).and_return(privacy_policies_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).privacy_policies

        expect(result).to eq(privacy_policies_resource)
      end
    end
  end

  describe "#teacher_training_adviser" do
    context "with a GetIntoTeaching adapter" do
      it "returns a GIT TeacherTrainingAdviser::Resource" do
        client = described_class.new(adapter: CRM::Adapters::GetIntoTeaching::Client.new(base_url: "https://test.example.com", api_key: "test-key"))

        expect(client.teacher_training_adviser)
          .to be_a(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }
      let(:teacher_training_adviser_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeacherTrainingAdviser::Resource)
      end

      before { allow(adapter).to receive(:teacher_training_adviser).and_return(teacher_training_adviser_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).teacher_training_adviser

        expect(result).to eq(teacher_training_adviser_resource)
      end
    end
  end

  describe "#get_into_teaching" do
    context "with a GetIntoTeaching adapter" do
      it "returns a GIT GetIntoTeachingResource" do
        client = described_class.new(adapter: CRM::Adapters::GetIntoTeaching::Client.new(base_url: "https://test.example.com", api_key: "test-key"))

        expect(client.get_into_teaching)
          .to be_a(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }
      let(:get_into_teaching_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::GetIntoTeachingResource)
      end

      before { allow(adapter).to receive(:get_into_teaching).and_return(get_into_teaching_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).get_into_teaching

        expect(result).to eq(get_into_teaching_resource)
      end
    end
  end

  describe "#schools_experience" do
    context "with a GetIntoTeaching adapter" do
      it "returns a GIT SchoolsExperienceResource" do
        client = described_class.new(adapter: CRM::Adapters::GetIntoTeaching::Client.new(base_url: "https://test.example.com", api_key: "test-key"))

        expect(client.schools_experience)
          .to be_a(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }
      let(:schools_experience_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::SchoolsExperienceResource)
      end

      before { allow(adapter).to receive(:schools_experience).and_return(schools_experience_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).schools_experience

        expect(result).to eq(schools_experience_resource)
      end
    end
  end

  describe "#operations" do
    context "with a GetIntoTeaching adapter" do
      it "returns a GIT OperationResource" do
        client = described_class.new(adapter: CRM::Adapters::GetIntoTeaching::Client.new(base_url: "https://test.example.com", api_key: "test-key"))

        expect(client.operations)
          .to be_a(CRM::Adapters::GetIntoTeaching::Resources::OperationResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }
      let(:operation_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::OperationResource)
      end

      before { allow(adapter).to receive(:operations).and_return(operation_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).operations

        expect(result).to eq(operation_resource)
      end
    end
  end

  describe "#teaching_events" do
    context "with a GetIntoTeaching adapter" do
      it "returns a GIT TeachingEventsResource" do
        client = described_class.new(adapter: CRM::Adapters::GetIntoTeaching::Client.new(base_url: "https://test.example.com", api_key: "test-key"))

        expect(client.teaching_events)
          .to be_a(CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource)
      end
    end

    context "with an injected adapter" do
      let(:adapter) { instance_double(CRM::Adapters::GetIntoTeaching::Client) }
      let(:teaching_events_resource) do
        instance_double(CRM::Adapters::GetIntoTeaching::Resources::TeachingEventsResource)
      end

      before { allow(adapter).to receive(:teaching_events).and_return(teaching_events_resource) }

      it "delegates to the injected adapter" do
        result = described_class.new(adapter: adapter).teaching_events

        expect(result).to eq(teaching_events_resource)
      end
    end
  end
end
