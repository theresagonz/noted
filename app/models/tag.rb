class Tag < ActiveRecord::Base
  has_many :tag_nuggets
  has_many :nuggets, through: :tag_nuggets
end
