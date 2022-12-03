module HashedId
  extend ActiveSupport::Concern

  included do
    before_validation :generate_hashed_id, on: [:create]
  end

  def generate_hashed_id
    self.hashed_id = Digest::SHA1.hexdigest([Time.now, rand].join)[...32]
  end

  def to_param
    hashed_id
  end
end
