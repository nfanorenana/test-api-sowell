FactoryBot.define do
  factory :visit_schedule do
    due_at { Date.today.next_month }
    place { association :place, company: checklist.company }
    spot { nil }
    residence { nil }
    # spot { association :spot, place: place }
    # residence { association :residence, company: checklist.company }
    checklist
  end
end
