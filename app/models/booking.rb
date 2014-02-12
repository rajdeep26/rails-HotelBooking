class Booking < ActiveRecord::Base
  has_many :rooms, dependent: :destroy
  has_one :contact, dependent: :destroy

  validates :amount, presence: true
  validates :check_in, presence: true
  validates :check_out, presence: true

  accepts_nested_attributes_for :contact, :rooms
end
