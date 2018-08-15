class User < ActiveRecord::Base
  has_many :notes
  has_many :tags, through: :notes
  has_secure_password

  validates :name,      presence: true
  validates :username,  presence: true,
                        uniqueness: true
  validates :password,  presence: true,
                        confirmation: true
  validates :password_confirmation, presence: true
end
