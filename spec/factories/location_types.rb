FactoryBot.define do
  factory :location_type do
    name { Faker::Name.initials }
    logo_url { "MyString" }
    company { association :company }
    nature { 0 }
  end
end
