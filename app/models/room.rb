class Room < ActiveRecord::Base
  has_one :room_type
  belongs_to :booking

  validates :adult, presence: true
  validates :children, presence: true
  validates :booking_id, presence: true
  validates :room_type_id, presence: true
end
