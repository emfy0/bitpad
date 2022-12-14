require 'dry/transaction'

class Wallets::ImportWallet
  include Dry::Transaction

  step :validate
  step :create_wallet

  private

  def validate(params:, current_user:, token:)
    wallet_form = Wallets::ImportForm.new(params)

    if wallet_form.valid?
      Success(attrs: wallet_form.attributes, wallet_form:, current_user:, token:)
    else
      Failure(wallet_form:, errors: wallet_form.errors)
    end
  end

  def create_wallet(attrs:, current_user:, wallet_form:, token:)
    key = Bitcoin::Key.from_base58(attrs[:base58])

    case Wallets::CreateWallet.new.(current_user:, token:, key:, name: attrs[:name])
    in Success(wallet)
      Success(wallet)
    in Failure(errors: errors)
      Failure(wallet_form:, errors:)
    end
  end
end
