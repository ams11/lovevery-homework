class Child < ApplicationRecord
  has_many :orders
  has_many :gifts

  def purchases
    orders + gifts
  end
end
