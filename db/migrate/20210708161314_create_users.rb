# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :code
      t.string :fname, null: false
      t.string :lname, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :one_time_password_digest
      t.string :status, null: false, default: 0
      t.jsonb :notifications, default: []
      t.jsonb :recipients, default: []
      t.boolean :email_notifications_activated, default: true
      t.boolean :can_close_issues, default: false
      t.jsonb :hardware, default: {}
      t.datetime :last_connection_at
      t.timestamps

      t.references :company, foreign_key: true, index: true
    end

    add_index :users, :email, unique: true
  end
end
