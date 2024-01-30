FactoryBot.define do
  factory :spot do
    name { Faker::Address.secondary_address }
    place { association :place }
    location_type { association :location_type, company: place.company }
  end
end
