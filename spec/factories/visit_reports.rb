FactoryBot.define do
  factory :visit_report do
    checkpoints { [{ "id" => visit_schedule.checklist.checkpoints.first.id, "status" => "ok" }] }
    issue_reports_count { 0 }
    author { association :author, company: visit_schedule.place.company }
    visit_schedule
  end
end
