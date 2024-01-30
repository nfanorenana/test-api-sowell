class CreateCheckpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :checkpoints do |t|
      t.string :question, null: false
      t.string :description
      t.references :checklist, foreign_key: true, index: true
      t.references :issue_type, foreign_key: true, index: true

      t.timestamps
    end
  end
end
