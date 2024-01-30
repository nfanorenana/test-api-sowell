class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.references :company, foreign_key: true, index: true
      t.references :residence, foreign_key: true, index: true

      t.timestamps
    end
  end
end
