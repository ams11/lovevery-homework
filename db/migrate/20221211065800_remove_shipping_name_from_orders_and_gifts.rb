class RemoveShippingNameFromOrdersAndGifts < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :shipping_name, :string
    remove_column :gifts, :shipping_name, :string

    change_column :addresses, :shipping_name, :string, null: false
  end
end
