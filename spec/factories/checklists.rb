FactoryBot.define do
  factory :checklist do
    name { Faker::Name.initials }
    logo_url { "MyString" }
    is_planned { true }
    recurrence { 1.month }
    company { association :company }
    location_type { association :location_type, company: company }

    after(:create) do |checklist|
      base_location_type = create(:base_location_type)
      base_issue_type = create(:base_issue_type, base_location_type: base_location_type)
      location_type = create(:location_type, base_location_type: base_location_type, company: checklist.company)
      issue_type = create(:issue_type, location_type: location_type, company: checklist.company, base_issue_type: base_issue_type)
  # let(:issue_type) { create(:issue_type, base_issue_type: base_issue_type, location_type: location_type, company: company) }

      create(:checkpoint, checklist: checklist, issue_type: issue_type)

      checklist.reload
    end
  end
end
