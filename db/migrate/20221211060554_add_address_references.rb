class AddAddressReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :address, null: true, foreign_key: true
    add_reference :gifts, :address, null: true, foreign_key: true
  end
end
