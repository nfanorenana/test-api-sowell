class CreateResidences < ActiveRecord::Migration[7.0]
  def change
    create_table :residences do |t|
      t.string :name, null: false
      t.references :company, foreign_key: true, index: true
      t.references :agency, foreign_key: true, index: true

      t.timestamps
    end
  end
end
