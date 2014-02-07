class RoomType < ActiveRecord::Base
  belongs_to :room

  validates :name, presence: true
  validates :desc, presence: true
  validates :room_count, presence: true
end
