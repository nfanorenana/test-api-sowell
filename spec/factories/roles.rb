FactoryBot.define do
  factory :role do
    name { "superadmin" }
    user { association :user }
    sector { association :sector }
  end
end
