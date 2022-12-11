class ProductPurchase < ApplicationRecord
  self.abstract_class = true

  belongs_to :product
  belongs_to :child
  belongs_to :shipping_address, foreign_key: :address_id, class_name: Address.to_s, autosave: true, dependent: :destroy

  before_validation :generate_user_facing_id
  validates :shipping_name, :product_id, :child_id, :shipping_address, presence: true

  def to_param
    user_facing_id
  end

  private

  def generate_user_facing_id
    self.user_facing_id ||= SecureRandom.uuid[0..7]
  end
end
