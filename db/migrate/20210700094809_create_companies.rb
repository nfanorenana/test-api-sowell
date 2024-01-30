# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :logo_url
      t.string :logo_base64
      t.timestamps
    end

    add_index :companies, :name, unique: true
  end
end
