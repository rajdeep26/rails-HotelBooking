class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :booking_code
      t.integer :amount
      t.date :check_in
      t.date :check_out

      t.timestamps
    end
  end
end
