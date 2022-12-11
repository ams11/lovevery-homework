require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "#validations" do
    it "requires shipping_address" do
      address = Address.new

      expect(address.valid?).to eq(false)
      expect(address.errors.count).to eq(3)
      expect(address.errors[:shipping_name]).to eq(["can't be blank"])
      expect(address.errors[:address]).to eq(["can't be blank"])
      expect(address.errors[:zipcode]).to eq(["can't be blank"])
    end
  end
end
