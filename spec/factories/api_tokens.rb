FactoryBot.define do
  factory :api_token do
    integration
    hashed_token { "MyString" }
    last_used_at { "2026-05-29 14:56:30" }
  end
end
