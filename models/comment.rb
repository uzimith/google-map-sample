class Comment < ActiveRecord::Base
  validates :name, :text, presence: true
  belongs_to :spot, counter_cache: true
end
