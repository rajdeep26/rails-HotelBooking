class Booking < ActiveRecord::Base
  has_many :rooms
  has_one :contact

  validates :amount, presence: true
  validates :check_in, presence: true
  validates :check_out, presence: true
end
