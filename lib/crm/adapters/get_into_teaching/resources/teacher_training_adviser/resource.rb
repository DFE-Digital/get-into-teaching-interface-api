module CRM
  module Adapters
    module GetIntoTeaching
      module Resources
        module TeacherTrainingAdviser
          class Resource < CRM::Adapters::GetIntoTeaching::Resource
            def candidates(body)
              post_request("/api/teacher_training_adviser/candidates", body:)
            end
          end
        end
      end
    end
  end
end
