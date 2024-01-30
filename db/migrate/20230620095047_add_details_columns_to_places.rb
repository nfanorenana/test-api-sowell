class AddDetailsColumnsToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :zip, :string, null: false, default: ""
    add_column :places, :city, :string, null: false, default: ""
    add_column :places, :country, :string, null: false, default: ""
    add_column :places, :street_number, :integer
    add_column :places, :street_name, :string
  end
end
