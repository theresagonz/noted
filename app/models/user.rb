class User < ActiveRecord::Base
  has_many :nuggets
  has_many :tags, through: :nuggets
  has_secure_password

  validates :name,      presence: true
  validates :username,  presence: true,
                        uniqueness: true
  validates :password,  presence: true,
                        confirmation: true
  validates :password_confirmation, presence: true
end
