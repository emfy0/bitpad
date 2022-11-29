require 'dry/transaction'

class Wallets::CreateWallet
  include Dry::Transaction

  step :validate_params
  step :create_user

  private

  def validate_params(params)
    wallet_from = Wallets::CreateForm.new(params)

    if wallet_from.validate
      Success(params)
    else
      Failure(wallet_from:, errors: wallet_from.errors)
    end
  end

  def create_user(params)
    Success(User.create(params))
  end
end
