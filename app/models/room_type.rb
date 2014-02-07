class RoomType < ActiveRecord::Base
  has_many :room

  validates :name, presence: true
  validates :desc, presence: true
  validates :room_count, presence: true
end
