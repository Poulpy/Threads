class AddConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column :reservations, :equipment_id, :uuid, null: false
    change_column :reservations, :user_id, :uuid, null: false
    change_column :reservations, :starts_at, :datetime, null: false
    change_column :reservations, :ends_at, :datetime, null: false
    add_index :reservations, :equipment_id
    add_index :reservations, :user_id
  end
end
