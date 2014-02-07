class RoomType < ActiveRecord::Base
  has_many :rooms

  validates :name, presence: true
  validates :description, presence: true
  validates :room_count, presence: true
end
