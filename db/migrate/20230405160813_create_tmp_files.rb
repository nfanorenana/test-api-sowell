class CreateTmpFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :tmp_files do |t|
      t.binary :file_data
      t.string :filename
      t.string :resource_type
      t.bigint :resource_id

      t.timestamps
    end
  end
end
