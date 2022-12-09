class CreateGifts < ActiveRecord::Migration[6.0]
  def change
    create_table :gifts do |t|
      t.string :user_facing_id, null: false, unique: true, comment: "A user-facing ID we can give the user to track their gift order in our system"
      t.references :product, null: false, foreign_key: true, comment: "What product is this gift order for?"
      t.references :child, null: false, foreign_key: true, comment: "Which child is this gift order for?"
      t.string :shipping_name, null: false, comment: "Name of who we are shipping to"
      t.string :address, null: false, comment: "Street Address for shipping"
      t.string :zipcode, null: false, comment: "Zip Code for shipping"
      t.boolean :paid, null: false, comment: "True if this gift order has been paid via a successful charge"
      t.string :gift_comment, comment: "Optional gift message"

      t.timestamps
    end
  end
end
