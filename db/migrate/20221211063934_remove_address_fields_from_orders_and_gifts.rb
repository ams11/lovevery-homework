class RemoveAddressFieldsFromOrdersAndGifts < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :address
    remove_column :orders, :zipcode
    remove_column :gifts, :address
    remove_column :gifts, :zipcode

    change_column :orders, :address_id, :integer, null: false
    change_column :gifts, :address_id, :integer, null: false
  end
end
