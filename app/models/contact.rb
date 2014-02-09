class Contact < ActiveRecord::Base
  belongs_to :booking

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
end
