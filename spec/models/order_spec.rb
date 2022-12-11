require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "#validations" do
    it "requires shipping_address" do
      order = Order.new(
        product: Product.new,
        shipping_address: nil,
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:shipping_address].size).to eq(2)
    end
  end
end
