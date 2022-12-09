class GiftsController < ApplicationController
  def new
    if product
      render :new, locals: { gift: Gift.new(product: product) }
    else
      flash[:error] = "Product not found"
      redirect_to products_path
    end
  end

  def create
    child = Child.find_or_create_by(child_params)
    gift = Gift.create(gift_params.merge(child: child))
    if gift.valid?
      Purchaser.new.purchase(gift, credit_card_params)
      redirect_to gift_path(gift)
    else
      render :new, locals: { gift: gift }
    end
  end

  def show
    @gift = Gift.find_by(id: params[:id]) || Gift.find_by(user_facing_id: params[:id])
  end

  private

  def gift_params
    params.require(:gift).permit(:shipping_name, :product_id, :zipcode, :address).merge(paid: false)
  end

  def child_params
    {
      full_name: params.require(:gift)[:child_full_name],
      parent_name: params.require(:gift)[:shipping_name],
      birthdate: Date.parse(params.require(:gift)[:child_birthdate]),
    }
  end

  def credit_card_params
    params.require(:gift).permit( :credit_card_number, :expiration_month, :expiration_year)
  end

  def product
    @product ||= Product.find_by(id: params[:product_id])
  end
end
