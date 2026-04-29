require "rails_helper"

RSpec.describe CRM::Resources::PickListItems::CandidateResource do
  subject(:resource) { described_class.new }

  describe "#initial_teacher_training_years" do
    it "raises NotImplementedError" do
      expect { resource.initial_teacher_training_years }.to raise_error(NotImplementedError)
    end
  end

  describe "#preferred_education_phases" do
    it "raises NotImplementedError" do
      expect { resource.preferred_education_phases }.to raise_error(NotImplementedError)
    end
  end

  describe "#channels" do
    it "raises NotImplementedError" do
      expect { resource.channels }.to raise_error(NotImplementedError)
    end
  end

  describe "#mailing_list_subscription_channels" do
    it "raises NotImplementedError" do
      expect { resource.mailing_list_subscription_channels }.to raise_error(NotImplementedError)
    end
  end

  describe "#event_subscription_channels" do
    it "raises NotImplementedError" do
      expect { resource.event_subscription_channels }.to raise_error(NotImplementedError)
    end
  end

  describe "#teacher_training_adviser_subscription_channels" do
    it "raises NotImplementedError" do
      expect { resource.teacher_training_adviser_subscription_channels }.to raise_error(NotImplementedError)
    end
  end

  describe "#gcse_status" do
    it "raises NotImplementedError" do
      expect { resource.gcse_status }.to raise_error(NotImplementedError)
    end
  end

  describe "#gcse_statuses" do
    it "raises NotImplementedError" do
      expect { resource.gcse_statuses }.to raise_error(NotImplementedError)
    end
  end

  describe "#retake_gcse_statuses" do
    it "raises NotImplementedError" do
      expect { resource.retake_gcse_statuses }.to raise_error(NotImplementedError)
    end
  end

  describe "#consideration_journey_stages" do
    it "raises NotImplementedError" do
      expect { resource.consideration_journey_stages }.to raise_error(NotImplementedError)
    end
  end

  describe "#adviser_eligibilities" do
    it "raises NotImplementedError" do
      expect { resource.adviser_eligibilities }.to raise_error(NotImplementedError)
    end
  end

  describe "#adviser_requirements" do
    it "raises NotImplementedError" do
      expect { resource.adviser_requirements }.to raise_error(NotImplementedError)
    end
  end

  describe "#types" do
    it "raises NotImplementedError" do
      expect { resource.types }.to raise_error(NotImplementedError)
    end
  end
end
