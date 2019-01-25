class User < ActiveRecord::Base
  has_many :notes, dependent: :destroy
  has_many :tags, through: :notes, dependent: :destroy
  has_secure_password

  validates :name,      presence: true
  validates :username,  presence: true,
                        uniqueness: true
  validates :password,  presence: true,
                        confirmation: true,
                        length: { minimum: 1 },
                        allow_nil: true
  validates :password_confirmation,
                        presence: true,
                        allow_nil: true

end
