class AddTalksToIssueReports < ActiveRecord::Migration[7.0]
  def change
    add_column :issue_reports, :talks, :jsonb, default: []
  end
end
