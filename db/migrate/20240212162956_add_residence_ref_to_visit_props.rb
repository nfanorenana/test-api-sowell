class AddResidenceRefToVisitProps < ActiveRecord::Migration[7.0]
  def change
    add_reference :visit_props, :residence, foreign_key: true

  end
end
