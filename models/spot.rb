class Spot < ActiveRecord::Base
  validates :name, :lng, :lat, :image, presence: true
  has_many :comments
end
