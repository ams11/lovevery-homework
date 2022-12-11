class CopyShippingNameToAddresses < ActiveRecord::Migration[6.0]
  def up
    Order.find_each do |order|
      order.shipping_address.update_columns(shipping_name: order.shipping_name)
    end

    Gift.find_each do |gift|
      gift.shipping_address.update_columns(shipping_name: gift.shipping_name)
    end
  end

  def down
  end
end
