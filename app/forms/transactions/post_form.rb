class Transactions::PostForm < ApplicationForm
  attr_accessor :volume, :recipient_address, :fee_rate, :hashed_id

  validates :volume, :recipient_address, :fee_rate, :hashed_id, presence: true

  validates :volume, numericality: { greater_than: 0, only_integer: true }
  validates :fee_rate, numericality: { greater_than: 0.5, less_than: 2 }

  validate :validate_volume
  validate :validate_recipient_address
  validate :validate_hashed_id

  def validate_hashed_id
    return if Wallet.find_by(hashed_id:)

    errors.add(:hashed_id, 'is invalid')
  end

  def validate_recipient_address
    return if Bitcoin.valid_address?(recipient_address)

    errors.add(:recipient_address, 'is invalid')
  end

  def validate_volume
    wallet = Wallet.find_by(hashed_id:)

    return if volume.to_f <= (wallet.satoshi_balance - fee_rate.to_f * wallet.next_transaction_bytes_count)

    errors.add(:volume, 'your balance does not allow you to send this amount')
  end

  def attributes
    { volume:, recipient_address:, fee_rate:, hashed_id: }
  end
end
