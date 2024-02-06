FactoryBot.define do
  factory :location_type do
    name { Faker::Name.initials }
    logo_url { "MyString" }
    base_location_type { association :base_location_type }
    company { association :company }
    nature { 0 }
  end
end
