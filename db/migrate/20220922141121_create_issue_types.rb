class CreateIssueTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_types do |t|
      t.string :name
      t.string :logo_url
      t.references :company, foreign_key: true, index: true
      t.references :location_type, foreign_key: true, index: true

      t.timestamps
    end
  end
end
