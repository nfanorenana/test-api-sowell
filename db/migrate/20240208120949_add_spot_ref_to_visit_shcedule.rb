class AddSpotRefToVisitShcedule < ActiveRecord::Migration[7.0]
  def change
    add_reference :visit_schedules, :spot, foreign_key: true
  end
end
