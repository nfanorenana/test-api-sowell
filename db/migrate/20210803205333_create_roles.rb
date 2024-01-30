# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :scope, foreign_key: true
      t.integer :name, null: false

      t.timestamps
    end
  end
end
