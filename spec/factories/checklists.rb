FactoryBot.define do
  factory :checklist do
    name { Faker::Name.initials }
    logo_url { "MyString" }
    is_planned { true }
    recurrence { 1.month }
    company { association :company }

    after(:create) do |checklist|
      issue_type = create(:issue_type, company: checklist.company)
      create(:checkpoint, checklist: checklist, issue_type: issue_type)

      checklist.reload
    end
  end
end
