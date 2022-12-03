class Users::CreateForm < ApplicationForm
  attr_accessor :login, :token

  validates :login, presence: true, length: { minimum: 3, maximum: 20 }
  validates :token, presence: true, length: { minimum: 32, maximum: 32 }, format: { with: /\A[a-fA-F0-9]+\z/ }

  def attributes
    { login:, token: }
  end
end
