class AddShippingNameToAddresses < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :shipping_name, :string
  end
end
