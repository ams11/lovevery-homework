class MoveAddressesToTable < ActiveRecord::Migration[6.0]
  def up
    Order.find_each do |order|
      order.shipping_address = Address.create!(address: order.address, zipcode: order.zipcode)
      order.save!
    end

    Gift.find_each do |gift|
      gift.shipping_address = Address.create!(address: gift.address, zipcode: gift.zipcode)
      gift.save!
    end
  end

  def down
  end
end
