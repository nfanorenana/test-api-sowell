class UpdateUsersDefaultStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :status, 1
  end
end
