class Purchaser
  def initialize
  end

  def purchase(order, params)
    # Fake number to force a decline
    return false if params[:credit_card_number] == "4242424242424242"

    order.update_attribute(:paid, true)
  end
end
