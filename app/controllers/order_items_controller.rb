class OrderItemsController < ApplicationController
  before_action :check_item_exists, only: :create
  def create
    @order = current_order
    @order_item = @order.order_items.new(order_item_params)
    @order.save
    session[:order_id] = @order.id
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update_attributes!(order_item_params)
    @order_items = @order.order_items
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy!
    @order_items = @order.order_items
  end

private
  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
  # Check item exists in order_items.
  def check_item_exists
    store_location
    @order = current_order
    if @order_item = @order.order_items.find_by(product_id: params['order_item']['product_id'])
      flash[:danger] = "Item already added to cart!"
      redirect_to cart_url
    end
  end
end
