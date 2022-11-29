class Users::SharedValidations
  include Activesupport::Concern

  attr_accessor :login, :token

  validates :login, presence: true, length: { minimum: 3, maximum: 20 }
  validates :token, presence: true, length: { minimum: 64, maximum: 64 }, format: { with: /\A[a-fA-F0-9]+\z/ }
end
