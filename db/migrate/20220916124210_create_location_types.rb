class CreateLocationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :location_types do |t|
      t.string :name, null: false
      t.text :logo_url
      t.references :company, foreign_key: true, index: true

      t.timestamps
    end
  end
end
