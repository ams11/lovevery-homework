require 'rails_helper'

RSpec.describe Gift, type: :model do
  describe "#validations" do
    it "validates that the gift message cannot exceed 300 characters" do
      gift = Gift.new(
        product: Product.new,
        shipping_address: Address.new,
        gift_comment: "Happy" * 61
      )

      expect(gift.valid?).to eq(false)
      expect(gift.errors["gift_comment"]).to eq(["cannot exceed 300 characters."])
    end

    it "allows a nil gift message" do
      product = Product.create!(
        name: "product1",
        description: "description2",
        price_cents: 1000,
        age_low_weeks: 0,
        age_high_weeks: 12,
        )
      child = Child.create!(
        full_name: "Kim Jones",
        birthdate: "2019-03-03",
        parent_name: "Pat Jones",
        )
      address = Address.create!(
        shipping_name: "A name",
        address: "123 Some Road",
        zipcode: "90210",
      )
      gift = Gift.new(
        product: product,
        child: child,
        shipping_address: address,
        gift_comment: nil,
        paid: true,
      )

      expect(gift.valid?).to eq(true)
    end
  end
end
