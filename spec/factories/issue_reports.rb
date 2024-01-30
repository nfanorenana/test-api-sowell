FactoryBot.define do
  factory :issue_report do
    message { Faker::Lorem.sentences(number: 3) }
    priority { 1 }
    imgs { nil }
    company { association :company }
    place { association :place, company: company }
    issue_type { association :issue_type, company: company }
    author { association :author, company: company }
    spot { nil }
    talks { [] }
  end
end
