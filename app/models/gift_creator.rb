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
    # generate a Hash with empty values if @child is nil or if there are no purchases for them
    last_purchase = @child&.purchases&.last
    { address_id: last_purchase&.shipping_address&.id }
  end
end