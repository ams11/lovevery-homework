class GiftCreator
  def initialize(child_params, gift_params)
    @child = Child.find_by(child_params)
    @params = gift_params.merge(child: @child)
  end

  def create
    Gift.create(@params.merge(address_hash))
  end

  private

  def address_hash
    last_purchase = @child&.purchases&.last
    { address: last_purchase&.address, zipcode: last_purchase&.zipcode }
  end
end