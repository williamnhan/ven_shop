class ProductsController < ApplicationController
  def index
  	@categories = Category.all
  	@category = Category.exists?(params[:category]) ? Category.find(params[:category]) : false
  	if @category
  		@products = @category.products.paginate(page: params[:page], per_page: 8)
  	else
      @products = Product.paginate(page: params[:page], per_page: 8)
     end
    @order_item = current_order.order_items.new
  end
end
