class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.decimal :total, default: 0

      t.timestamps
    end
    add_index :orders, :user_id
  end
end
