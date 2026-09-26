class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment, id: :uuid do |t|
      t.string :name
      t.integer :category
      t.text :description

      t.timestamps
    end
  end
end
