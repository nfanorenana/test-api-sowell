FactoryBot.define do
  factory :base_issue_type do
    name { Faker::Name.initials }
    base_location_type { association :base_location_type }
  end
end
