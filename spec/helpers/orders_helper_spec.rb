require 'rails_helper'

RSpec.describe OrdersHelper, type: :helper do
  [Gift, Order].each do |klass|
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
