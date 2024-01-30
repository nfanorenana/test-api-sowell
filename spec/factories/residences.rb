FactoryBot.define do
  factory :residence do
    name { Faker::Name.initials }
    company
    agency { association :agency, company: company }
  end
end
