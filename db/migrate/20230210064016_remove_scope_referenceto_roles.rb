class RemoveScopeReferencetoRoles < ActiveRecord::Migration[7.0]
  def change
    remove_reference :roles, :scope, index: true
    add_reference :roles, :sector, foreign_key: true, index: true
  end
end
