class AddAddressesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :address, null: false, comment: "Street Address for shipping"
      t.string :zipcode, null: false, comment: "Zip Code for shipping"

      t.timestamps
    end
  end
end
