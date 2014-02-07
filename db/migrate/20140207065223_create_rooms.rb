class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :adult
      t.integer :children
      t.integer :booking_id
      t.integer :room_type_id

      t.timestamps
    end
  end
end
