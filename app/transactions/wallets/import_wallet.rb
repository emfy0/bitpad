require 'dry/transaction'

class Wallets::ImportWallet
  include Dry::Transaction

  step :validate

  private

  def validate(params, user)
    wallet_form = Wallets::ImportForm.new(params)

    if wallet_form.valid?
      Success(attrs: wallet_form.attributes, wallet_form:, user:)
    else
      Failure(wallet_form:, errors: wallet_form.errors)
    end
  end

  def create_wallet(attrs:, user:, wallet_form:)
    wallet = Wallet.new(name: attrs[:name], user:)

    if wallet.save
      Success(wallet)
    else
      Failure(wallet_form:, errors: wallet.errors)
    end
  end
end
