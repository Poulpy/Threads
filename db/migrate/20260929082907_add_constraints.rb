# frozen_string_literal: true

class AddConstraints < ActiveRecord::Migration[8.1]
  def change
    change_table(:reservations, bulk: true) do |t|
      t.column :equipment_id, :uuid, null: false # rubocop:disable Rails/NotNullColumn
      t.column :starts_at, :uuid, null: false, default: Time.zone.now
      t.column :ends_at, :uuid, null: false, default: Time.zone.now + 1.day
      t.add_index :equipment_id
      t.add_index :user_id
    end
  end
end
