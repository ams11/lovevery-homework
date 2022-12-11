require 'rails_helper'

RSpec.describe GiftCreator, type: :model do
  describe "#create" do
    it "creates a new Gift given valid parameters" do
      product = Product.create!(
        name: "product1",
        description: "description2",
        price_cents: 1000,
        age_low_weeks: 0,
        age_high_weeks: 12,
        )
      child_name = "Kim Jones"
      parent_name = "Pat Jones"
      birthdate = "2019-03-03"
      child = Child.create!(
        full_name: child_name,
        birthdate: birthdate,
        parent_name: parent_name,
        )
      address = Address.create!(
        shipping_name: parent_name,
        address: "1234 Broad St",
        zipcode: "12345",
        )
      order = Order.create!(
        product_id: product.id,
        child_id: child.id,
        address_id: address.id,
        paid: true,
        )

      child_params = {
        full_name: child_name,
        parent_name: parent_name,
        birthdate: birthdate,
      }
      gift_params = {
        product_id: product.id,
        paid: true,
      }
      gift = GiftCreator.new(child_params, gift_params).create
      expect(gift.valid?).to eq(true)
    end

    it "can get an address from a previous Gift" do
      product = Product.create!(
        name: "product1",
        description: "description2",
        price_cents: 1000,
        age_low_weeks: 0,
        age_high_weeks: 12,
        )
      child_name = "Kim Jones"
      parent_name = "Pat Jones"
      birthdate = "2019-03-03"
      child = Child.create!(
        full_name: child_name,
        birthdate: birthdate,
        parent_name: parent_name,
        )
      address = Address.create!(
        shipping_name: parent_name,
        address: "1234 Broad St",
        zipcode: "12345",
        )
      gift = Gift.create!(
        product_id: product.id,
        child_id: child.id,
        address_id: address.id,
        paid: true,
        )

      child_params = {
        full_name: child_name,
        parent_name: parent_name,
        birthdate: birthdate,
      }
      gift_params = {
        product_id: product.id,
        paid: true,
      }
      gift = GiftCreator.new(child_params, gift_params).create
      expect(gift.valid?).to eq(true)
    end

    it "returns an error if child cannot be found" do
      product = Product.create!(
        name: "product1",
        description: "description2",
        price_cents: 1000,
        age_low_weeks: 0,
        age_high_weeks: 12,
        )

      child_params = {
        full_name: "Not",
        parent_name: "Found",
        birthdate: "2000-01-12",
      }
      gift_params = {
        product_id: product.id,
        paid: true,
      }
      gift = GiftCreator.new(child_params, gift_params).create
      expect(gift.valid?).to eq(false)
      expect(gift.errors[:child]).to eq(["must exist"])
    end

    it "returns an error if a child is found, but it doesn't have any orders or gifts" do
      product = Product.create!(
        name: "product1",
        description: "description2",
        price_cents: 1000,
        age_low_weeks: 0,
        age_high_weeks: 12,
        )
      child_name = "Kim Jones"
      parent_name = "Pat Jones"
      birthdate = "2019-03-03"
      child = Child.create!(
        full_name: child_name,
        birthdate: birthdate,
        parent_name: parent_name,
        )

      child_params = {
        full_name: child_name,
        parent_name: parent_name,
        birthdate: birthdate,
      }
      gift_params = {
        product_id: product.id,
        paid: true,
      }
      gift = GiftCreator.new(child_params, gift_params).create
      expect(gift.valid?).to eq(false)
      expect(gift.errors.count).to eq(2)
      expect(gift.errors[:shipping_address]).to eq(["must exist", "can't be blank"])
    end
  end
end
