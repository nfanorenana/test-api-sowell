# frozen_string_literal: true

class CreateScopes < ActiveRecord::Migration[6.1]
  def change
    create_table :scopes do |t|
      t.string :name, null: false
      t.string :code
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
