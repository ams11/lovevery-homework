require 'rails_helper'

RSpec.describe ProductPurchase, type: :helper do
  [Gift, Order].each do |klass|
    describe "##{klass} validations" do
      it "raises errors about all required fields" do
        object = klass.new
        expect(object.valid?).to eq(false)
        expect(object.errors.count).to eq(6)
        expect(object.errors[:product]).to eq(["must exist"])
        expect(object.errors[:child]).to eq(["must exist"])
        expect(object.errors[:shipping_address]).to eq(["must exist", "can't be blank"])
        expect(object.errors[:product_id]).to eq(["can't be blank"])
        expect(object.errors[:child_id]).to eq(["can't be blank"])
      end
    end

    describe "##{klass}.to_param" do
      it "returns the value of user_facing_id" do
        object = klass.new(
          product: Product.new,
          )

        expect(object.valid?).to eq(false)    # validate to trigger the before_validation action
        expect(object.to_param).to eq(object.user_facing_id)
      end

      it "does not override the user_facing_id value if it's specified" do
        id = "890890908980980"
        object = klass.new(
          product: Product.new,
          user_facing_id: id,
          )

        expect(object.valid?).to eq(false)    # validate to trigger the before_validation action
        expect(object.to_param).to eq(id)
      end
    end
  end
end
