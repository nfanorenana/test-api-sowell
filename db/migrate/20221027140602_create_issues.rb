class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :message, null: false
      t.integer :priority, default: 0
      t.references :company, foreign_key: true, index: true
      t.references :place, foreign_key: true, index: true
      t.references :author, foreign_key: { to_table: :users }, index: true
      t.references :issue_type, foreign_key: true, index: true

      t.timestamps
    end
  end
end
