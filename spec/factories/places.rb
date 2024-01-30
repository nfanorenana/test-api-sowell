FactoryBot.define do
  factory :place do
    name { Faker::Name.initials }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
    country { Faker::Address.country }
    street_number { 101 }
    street_name { Faker::Address.street_name }
    company
    residence { association :residence, company: company }
  end
end
