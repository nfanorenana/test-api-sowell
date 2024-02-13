FactoryBot.define do
  factory :visit_prop do
    place { association :place, company: checkpoint.checklist.company }
    spot { association :spot, place: place }
    residence { association :residence, company: checkpoint.checklist.company }
    checkpoint { association :checkpoint }
  end
end
