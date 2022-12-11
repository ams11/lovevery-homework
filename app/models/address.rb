class Address < ApplicationRecord
  has_many :orders
  has_many :gifts

  validates :address, :zipcode, presence: true
end
