class CreateBaseIssueTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :base_issue_types do |t|
      t.string :name, null: false
      t.references :base_location_type, foreign_key: true, index: true
      t.timestamps
    end
  end
end
