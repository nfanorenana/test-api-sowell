class AddRecurrenceToChecklists < ActiveRecord::Migration[7.0]
  def change
    add_column :checklists, :recurrence, :interval
  end
end
