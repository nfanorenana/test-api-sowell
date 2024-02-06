class AddBaseLocationTypeRefToLocationType < ActiveRecord::Migration[7.0]
  def change
    add_reference :location_types, :base_location_type, null: false, foreign_key: true
  end
end
