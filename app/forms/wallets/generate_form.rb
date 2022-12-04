class Wallets::GenerateForm < ApplicationForm
  attr_accessor :name

  validates :name, presence: true, length: { minimum: 3, maximum: 20 }

  def attributes
    { name: }
  end
end
