class Wallets::CreateWallet
  def call(current_user:, token:, key:, name:)
    encryptor = ActiveSupport::MessageEncryptor.new(token)
    encrypted_data = encryptor.encrypt_and_sign(key.priv)

    wallet =
      Wallet.create(user: current_user, encrypted_private_key: encrypted_data, name:, address: key.addr)

    if wallet.valid?
      Success(
        wallet:,
        base58: key.to_base58
      )
    else
      Failure(
        errors: wallet.errors
      )
    end
  end
end
