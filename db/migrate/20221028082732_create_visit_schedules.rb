class CreateVisitSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :visit_schedules do |t|
      t.date :due_at
      t.references :place, foreign_key: true, index: true
      t.references :checklist, foreign_key: true, index: true

      t.timestamps
    end
  end
end
