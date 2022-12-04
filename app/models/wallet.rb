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

  after_update_commit do
    broadcast_update_to [user, :wallets], target: self, partial: 'users/wallet', locals: { wallet: self }
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

  def utxo_id
    @utxo_id ||= BlockstreamApi.utxo_ids_by_addr(address)
  end

  def next_transaction_bytes_count
    utxo_id.count * 148 + 34 * 2 + 10
  end

  def turbo_update
    broadcast_update_to [user, :wallets], target: self, partial: 'users/wallet', locals: { wallet: self }
  end
end
