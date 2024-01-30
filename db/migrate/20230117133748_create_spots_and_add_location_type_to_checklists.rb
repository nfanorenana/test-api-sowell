class CreateSpotsAndAddLocationTypeToChecklists < ActiveRecord::Migration[7.0]
  def change
    create_table :spots do |t|
      t.string :name, null: false
      t.references :location_type, foreign_key: true, index: true
      t.references :place, foreign_key: true, index: true
      t.timestamps
    end

    add_reference :checklists, :location_type, foreign_key: true, index: true
    add_reference :issue_reports, :spot, foreign_key: true, index: true
  end
end
