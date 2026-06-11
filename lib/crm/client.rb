module CRM
  class Client
    def initialize(adapter: CRM::Adapters::Demo::Client.new)
      @adapter = adapter
    end

    def lookup_items
      @adapter.lookup_items
    end

    def pick_list_items
      @adapter.pick_list_items
    end

    def callback_booking_quotas
      @adapter.callback_booking_quotas
    end

    def teaching_event_buildings
      @adapter.teaching_event_buildings
    end

    def privacy_policies
      @adapter.privacy_policies
    end

    def teacher_training_adviser
      @adapter.teacher_training_adviser
    end

    def candidates
      @adapter.candidates
    end
  end
end
