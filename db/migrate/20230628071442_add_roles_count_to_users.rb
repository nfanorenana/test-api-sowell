class AddRolesCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :roles_count, :integer
  end
end
