class OrdersController < ApplicationController
  include PurchasesHelper

  before_action :validate_product, only: :new

  def new
    @order = Order.new(product: product)
  end

  def create
    child = Child.find_or_create_by(child_params)
    @order = Order.create(order_params.merge(child: child, user_facing_id: SecureRandom.uuid[0..7]))
    if child.valid? && @order.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      render :new, locals: { errors: child.errors.any? ? child.errors : @order.errors }
    end
  end

  def show
    @order = Order.find_by(id: params[:id]) || Order.find_by(user_facing_id: params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:product_id).merge(paid: false, shipping_address_attributes: address_params)
  end

  def address_params
    params.require(:order).permit(:shipping_name, :zipcode, :address)
  end

  def product
    @product ||= Product.find_by(id: params[:product_id])
  end

  def validate_product
    unless product
      flash[:error] = "Product not found"
      redirect_to products_path
    end
  end
end
