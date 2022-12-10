class ProductsController < ApplicationController
  before_action :ensure_product, only: :show

  def index
    @products = Product.all.order(:age_low_weeks)
  end

  def show
  end

  private

  def product
    @product ||= Product.find_by(id: params[:id])
  end

  def ensure_product
    unless product
      flash[:error] = "Product not found"
      redirect_to products_path
    end
  end
end
