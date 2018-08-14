class TagNugget < ActiveRecord::Base
  belongs_to :tag
  belongs_to :nugget
end
