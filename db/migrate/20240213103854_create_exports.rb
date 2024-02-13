class CreateExports < ActiveRecord::Migration[7.0]
  def change
    create_table :exports do |t|
      t.string :name
      t.integer :status
      t.string :url
      t.jsonb :params, null: false, default: '{}'
      t.integer :author_id

      t.timestamps
    end
  end
end
