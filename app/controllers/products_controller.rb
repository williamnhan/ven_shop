class ProductsController < ApplicationController
  before_action :get_category_and_order_item
  def index
    if @category
      @products = Product.where( category_id: @category.id ).paginate( page: params[:page], per_page: 8 )
    else
      @products = Product.paginate( page: params[:page], per_page: 8 )
    end
  end

  def search
    search_params = { q: "name:#{params[:search]}", sort: 'created_at desc', wt: 'ruby', fl: 'id' }
    response = ProductsSolrConnection.get( 'select', params: search_params )
    @numFound = response['response']['numFound']
    @products = Product.find(response['response']['docs'].collect {|ind| ind['id']})

  end

  def show
    @product = Product.find(params[:id])
  end

private
  def get_category_and_order_item
    @categories = Category.all
    @category = @categories.find { |item| item.id.to_s == params[:category] }
    @order_item = current_order.order_items.new
  end
end
