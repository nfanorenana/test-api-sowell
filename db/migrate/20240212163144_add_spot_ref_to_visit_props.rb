class AddSpotRefToVisitProps < ActiveRecord::Migration[7.0]
  def change
    add_reference :visit_props, :spot, foreign_key: true

  end
end
