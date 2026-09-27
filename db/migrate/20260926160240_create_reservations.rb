# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :equipment_id
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
