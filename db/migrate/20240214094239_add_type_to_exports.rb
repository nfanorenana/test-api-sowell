class AddTypeToExports < ActiveRecord::Migration[7.0]
  def change
    add_column :exports, :file_type, :string
  end
end
