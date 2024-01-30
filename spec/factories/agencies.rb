FactoryBot.define do
  factory :agency do
    name { Faker::Name.initials }
    company { association :company }
  end
end
