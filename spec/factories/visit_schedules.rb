FactoryBot.define do
  factory :visit_schedule do
    due_at { Date.today.next_month }
    place { association :place, company: checklist.company }
    checklist
  end
end
