class ProductsController < ApplicationController
  before_action :getCategoryAndOrderItem
  def index
    if @category
      @products = Product.where( category_id: @category.id ).paginate( page: params[:page], per_page: 8 )
    else
      @products = Product.paginate( page: params[:page], per_page: 8 )
    end
  end

  def search
    # @products = ProductsSolrConnection.get 'select', :params => {:q => '*:*'}
    search_params = { q: "name:#{params[:search]}", sort: 'created_at desc' }
    @response = ProductsSolrConnection.get( 'select', params: search_params )
  end

  def show
    @product = Product.find(params[:id])
  end

private
  def getCategoryAndOrderItem
    @categories = Category.all
    @category = @categories.find { |item| item.id.to_s == params[:category] }
    @order_item = current_order.order_items.new
  end
end
