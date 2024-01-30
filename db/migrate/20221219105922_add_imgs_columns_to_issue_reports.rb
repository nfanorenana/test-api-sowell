class AddImgsColumnsToIssueReports < ActiveRecord::Migration[7.0]
  def change
    add_column :issue_reports, :imgs, :jsonb
  end
end
