class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @category = @categories.find { |item| item.id.to_s == params[:category] }
    if @category
      @products = Product.where( category_id: @category.id ).paginate( page: params[:page], per_page: 8 )
    else
      @products = Product.paginate( page: params[:page], per_page: 8 )
    end
    @order_item = current_order.order_items.new
  end
end
