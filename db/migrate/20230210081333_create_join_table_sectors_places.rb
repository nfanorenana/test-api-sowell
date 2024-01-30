class CreateJoinTableSectorsPlaces < ActiveRecord::Migration[7.0]
  def change
    create_join_table :sectors, :places do |t|
      t.index [:sector_id, :place_id]
      t.index [:place_id, :sector_id]
    end
  end
end
