FactoryBot.define do
  factory :sector do
    name { Faker::Company.unique.buzzword }
    code { Faker::Company.unique.sic_code }
    company { association :company }

    factory :sector_with_places do
      transient do
        places_count { 1 }
      end

      after(:create) do |sector, evaluator|
        create_list(:place, evaluator.places_count, sectors: [sector], company: sector.company)
      end
    end
  end
end
