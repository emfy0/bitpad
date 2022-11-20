class User < ApplicationRecord
  has_many :wallets
  has_secure_password :token

  validates :login, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
end
