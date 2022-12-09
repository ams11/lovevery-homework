require 'rails_helper'

RSpec.describe Gift, type: :model do
  describe "#validations" do
    it "requires shipping_name" do
      gift = Gift.new(
        product: Product.new,
        shipping_name: nil,
        address: "123 Some Road",
        zipcode: "90210",
        user_facing_id: "890890908980980",
        gift_comment: "Happy Birthday!"
      )

      expect(gift.valid?).to eq(false)
      expect(gift.errors[:shipping_name].size).to eq(1)
    end
  end
end
