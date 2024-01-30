FactoryBot.define do
  factory :checkpoint do
    question { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    issue_type
    checklist { association :checklist, company: issue_type.company }
  end
end
