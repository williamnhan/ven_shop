class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @category = @categories.find { |category| category.id = params[:category] }
    if @category
      @products = @category.products.paginate(page: params[:page], per_page: 8)
    else
      @products = Product.paginate(page: params[:page], per_page: 8)
    end
    @order_item = current_order.order_items.new
  end
end
