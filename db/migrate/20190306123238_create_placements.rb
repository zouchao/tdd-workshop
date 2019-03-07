class CreatePlacements < ActiveRecord::Migration[5.2]
  def change
    create_table :placements do |t|
      t.references :toy, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
