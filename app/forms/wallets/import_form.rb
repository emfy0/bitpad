require 'bitcoin'

class Wallets::ImportForm < ApplicationForm
  attr_accessor :base58

  validate :base58_format
  validates :base58, presence: true

  validates :name, presence: true, length: { minimum: 3, maximum: 20 }

  def base58_format
    Bitcoin::Key.from_base58(base58)
    # rubocop:disable Style/RescueStandardError
  rescue => e
    # rubocop:enable Style/RescueStandardError
    errors.add(:base58, :invalid, e.message)
  end

  def attributes
    { base58:, name: }
  end
end
