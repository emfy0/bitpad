class Wallet < ApplicationRecord
  include ActionView::RecordIdentifier
  include HashedId

  attr_writer :satoshi_balance

  belongs_to :user

  validates :user_id, uniqueness: { scope: :address }

  after_create_commit do
    broadcast_prepend_to(
      [user, :wallets], target: dom_id(user, :wallets), partial: 'users/wallet', locals: { wallet: self }
    )
  end

  after_destroy_commit do
    broadcast_remove_to [user, :wallets], target: self
  end

  def satoshi_balance
    @satoshi_balance ||= BlockstreamApi.addr_balace(address)
  end

  def balance
    @balance ||= satoshi_balance / 100_000_000.to_f
  end

  def usd_balance
    @usd_balance ||= balance * BitfinexApi.exchange_rate_of('BTC', 'USD')
  end

  def utxo_ids
    @utxo_id ||= BlockstreamApi.utxo_ids_by_addr(address)
  end

  def utxo_list
    @utxo_list ||= utxo_ids.map { |tx_id| BlockstreamApi.transaction_by_id tx_id }
  end

  def next_transaction_bytes_count
    utxo_ids.count * 148 + 34 * 2 + 10
  end

  def last_transaction_hex_id(amount: 1)
    @last_transaction ||= BlockstreamApi.addr_transactions_hashed_ids(address).first(amount)
  end

  def turbo_update
    broadcast_update_to [user, :wallets], target: self, partial: 'users/wallet', locals: { wallet: self }
  end
end
