FactoryBot.define do
  factory :tmp_file do
    resource_type { "IssueReport" }
    filename { "1_0" }
    file_data { "file data" }
    resource_id { 1 }
  end
end
