class Wallets::CreateForm < ApplicationForm
  validates :login, presence: true, length: { minimum: 3, maximum: 20 }
end
