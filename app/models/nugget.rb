class Nugget < ActiveRecord::Base
  belongs_to :user
  has_many :tag_nuggets
  has_many :tags, through: :tag_nuggets
end
