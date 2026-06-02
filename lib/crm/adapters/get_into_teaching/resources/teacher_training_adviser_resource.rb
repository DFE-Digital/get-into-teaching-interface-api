module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        class TeacherTrainingAdviserResource < CRM::Resources::TeacherTrainingAdviserResource
          def initialize(client)
            @client = client
          end

          def candidates = TeacherTrainingAdviser::CandidatesResource.new(@client)
        end
      end
    end
  end
end
