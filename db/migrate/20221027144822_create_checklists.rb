class CreateChecklists < ActiveRecord::Migration[7.0]
  def change
    create_table :checklists do |t|
      t.string :name
      t.boolean :is_planned, default: true
      t.references :company, foreign_key: true, index: true

      t.timestamps
    end
  end
end
