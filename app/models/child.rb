class Child < ApplicationRecord
  has_many :orders
  has_many :gifts

  validates :full_name, :parent_name, :birthdate, presence: true

  def purchases
    orders + gifts
  end
end
