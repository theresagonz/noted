class User < ActiveRecord::Base
  has_many :nuggets
  has_many :tags, through: :nuggets
  has_secure_password
end
