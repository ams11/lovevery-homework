class Gift < ApplicationRecord
  include OrdersHelper

  belongs_to :product
  belongs_to :child

  before_validation :generate_user_facing_id
  validates :shipping_name, presence: true
end
