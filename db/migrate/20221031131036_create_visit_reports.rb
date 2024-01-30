class CreateVisitReports < ActiveRecord::Migration[7.0]
  def change
    create_table :visit_reports do |t|
      t.references :visit_schedule, foreign_key: true, index: true
      t.references :author, foreign_key: { to_table: :users }, index: true
      t.jsonb :checkpoints
      t.integer :issues_count

      t.timestamps
    end
  end
end
