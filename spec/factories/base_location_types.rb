FactoryBot.define do
  factory :base_location_type do
    name { Faker::Name.initials }
    depth_level { 1 }
  end
end
