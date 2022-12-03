class Wallet < ApplicationRecord
  include HashedId
  belongs_to :user
end
