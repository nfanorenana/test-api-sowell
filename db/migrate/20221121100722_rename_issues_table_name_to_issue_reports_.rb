class RenameIssuesTableNameToIssueReports < ActiveRecord::Migration[7.0]
  def change
    rename_table :issues, :issue_reports
    rename_column :users, :can_close_issues, :can_close_issue_reports
    rename_column :visit_reports, :issues_count, :issue_reports_count
  end
end
