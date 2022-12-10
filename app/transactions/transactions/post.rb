require 'dry/transaction'

class Transactions::Post
  include Dry::Transaction
  include Bitcoin::Builder

  step :validate
  step :create_transaction
  step :broadcast_transaction

  def validate(params:, current_user:, token:)
    transaction_form = Transactions::PostForm.new(params)

    if transaction_form.valid?
      Success(attrs: transaction_form.attributes, current_user:, token:)
    else
      Failure(transaction_form:, errors: transaction_form.errors)
    end
  end

  def create_transaction(attrs:, current_user:, token:)
    fee_rate = attrs[:fee_rate].to_f
    recipient_address = attrs[:recipient_address]
    volume = attrs[:volume].to_i
    hashed_id = attrs[:hashed_id]

    wallet = Wallet.where(hashed_id:, user: current_user).first

    return Failure[:no_such_wallet_for_user, 'Wallet not found'] unless wallet

    encryptor = ActiveSupport::MessageEncryptor.new(token)
    private_key = encryptor.decrypt_and_verify(wallet.encrypted_private_key)

    return Failure[:invalid_token, 'Invalid token'] if private_key.nil?

    builded_transaction = build_tx do |tx|
      wallet.utxo_list.uniq(&:hash).each do |utxo|
        make_transaction_input(
          transaction: tx,
          prev_transaction: utxo,
          prev_transaction_indexs:
            address_indexes_in_transaction_output(transaction: utxo, address: wallet.address),
          sign_key: Bitcoin::Key.new(private_key)
        )
      end

      tx.output do |o|
        o.value volume
        o.script { |s| s.recipient recipient_address }
      end

      tx.output do |o|
        o.value(wallet.satoshi_balance - volume - (fee_rate * wallet.next_transaction_bytes_count).to_i)
        o.script { |s| s.recipient wallet.address }
      end
    end

    Success(builded_transaction)
  end

  def broadcast_transaction(transaction)
    res = BlockstreamApi.broadcast_transaction transaction

    if res.is_a?(Net::HTTPSuccess)
      Success(transaction)
    else
      Failure[:transaction_wasnt_broadcasted, res.body]
    end
  end

  private

  def make_transaction_input(transaction:, prev_transaction:, prev_transaction_indexs:, sign_key:)
    prev_transaction_indexs.each do |prev_transaction_index|
      transaction.input do |i|
        i.prev_out prev_transaction
        i.prev_out_index prev_transaction_index
        i.signature_key sign_key
      end
    end
  end

  def address_indexes_in_transaction_output(transaction:, address:)
    transaction_out = transaction.to_hash(with_address: true)['out']
    transaction_out.each_index.select { |i| transaction_out[i]['address'] == address }
  end
end
