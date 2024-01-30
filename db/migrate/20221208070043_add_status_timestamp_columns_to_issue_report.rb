class AddStatusTimestampColumnsToIssueReport < ActiveRecord::Migration[7.0]
  def change
    add_column :issue_reports, :pending_timestamp, :datetime
    add_column :issue_reports, :ongoing_timestamp, :datetime
    add_column :issue_reports, :done_timestamp, :datetime
    add_column :issue_reports, :canceled_timestamp, :datetime
  end
end
