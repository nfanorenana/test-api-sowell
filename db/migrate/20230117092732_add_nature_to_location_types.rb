class AddNatureToLocationTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :location_types, :nature, :integer, null: false, default: 0
  end
end
