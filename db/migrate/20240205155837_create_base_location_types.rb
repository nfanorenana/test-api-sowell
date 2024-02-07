class CreateBaseLocationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :base_location_types do |t|
      t.string :name, null: false
      t.integer :depth_level, null: false
      t.timestamps
    end
  end
end
