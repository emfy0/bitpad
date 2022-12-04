class Transactions::PostForm < ApplicationForm
  attr_accessor :volume, :recipient_address, :fee_rate

  def attributes
    { volume:, recipient_address:, fee_rate: }
  end
end
