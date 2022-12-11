class Address < ApplicationRecord
  has_many :orders
  has_many :gifts

  validates :shipping_name, :address, :zipcode, presence: true
end
