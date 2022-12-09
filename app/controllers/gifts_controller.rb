class GiftsController < ApplicationController
  include PurchasesHelper

  def new
    if product
      render :new, locals: { gift: Gift.new(product: product) }
    else
      flash[:error] = "Product not found"
      redirect_to products_path
    end
  end

  def create
    gift = GiftCreator.new(child_params(base_params: params.require(:gift)), gift_params).create
    if gift.valid?
      Purchaser.new.purchase(gift, credit_card_params(base_params: params.require(:gift)))
      redirect_to gift_path(gift)
    else
      render :new, locals: { gift: gift }
    end
  end

  def show
    gift = Gift.includes(:child, :product).find_by(id: params[:id]) ||
      Gift.includes(:child, :product).find_by(user_facing_id: params[:id])
    render :show, locals: { gift: gift }
  end

  private

  def gift_params
    params.require(:gift).permit(:shipping_name, :product_id, :gift_comment).merge(paid: false)
  end

  def product
    @product ||= Product.find_by(id: params[:product_id])
  end
end
