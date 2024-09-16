class CreateVisitProps < ActiveRecord::Migration[7.0]
  def change
    create_table :visit_props do |t|
      t.references :place, foreign_key: true, index: true
      t.references :checkpoint, foreign_key: true, index: true

      t.timestamps
    end
  end
end
