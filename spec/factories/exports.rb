FactoryBot.define do
  factory :export do
    name { "MyString" }
    status { 1 }
    url { "MyString" }
    params { }
    author { association :author }
  end
end
