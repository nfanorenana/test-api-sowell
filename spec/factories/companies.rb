FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    logo_url { "MyString" }
    logo_base64 { "MyString" }
  end
end
