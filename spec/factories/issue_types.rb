FactoryBot.define do
  factory :issue_type do
    name { "MyString" }
    logo_url { "MyString" }
    base_issue_type { association :base_issue_type }
    company { association :company }
    location_type { association :location_type, company: company }
  end
end
