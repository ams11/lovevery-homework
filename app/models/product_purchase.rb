class ProductPurchase < ApplicationRecord
  self.abstract_class = true

  belongs_to :product
  belongs_to :child

  before_validation :generate_user_facing_id
  validates :shipping_name, :address, :zipcode, :product_id, :child_id, presence: true

  def to_param
    user_facing_id
  end

  private

  def generate_user_facing_id
    self.user_facing_id ||= SecureRandom.uuid[0..7]
  end
end
