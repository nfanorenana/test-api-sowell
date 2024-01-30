class AddVisitReportIdAndCheckpointIdToIssues < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :visit_report, foreign_key: true, index: true
    add_reference :issues, :checkpoint, foreign_key: true, index: true
  end
end
