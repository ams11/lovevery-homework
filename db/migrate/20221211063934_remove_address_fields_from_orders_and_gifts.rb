class RemoveAddressFieldsFromOrdersAndGifts < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :address, :string
    remove_column :orders, :zipcode, :string
    remove_column :gifts, :address, :string
    remove_column :gifts, :zipcode, :string

    change_column :orders, :address_id, :integer, null: false
    change_column :gifts, :address_id, :integer, null: false
  end
end
