require "rails_helper"

RSpec.describe CRM::Client do
  describe "#lookup_items" do
    context "with the default adapter" do
      it "returns a Demo LookUpItemsResource" do
        expect(described_class.new.lookup_items).to be_a(CRM::Adapters::Demo::Resources::LookUpItemsResource)
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
        expect(described_class.new.pick_list_items).to be_a(CRM::Adapters::Demo::Resources::PickListItemsResource)
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
        expect(described_class.new.callback_booking_quotas).to be_a(CRM::Adapters::Demo::Resources::CallbackBookingQuotasResource)
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
        expect(described_class.new.privacy_policies).to be_a(CRM::Adapters::Demo::Resources::PrivacyPoliciesResource)
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
end
