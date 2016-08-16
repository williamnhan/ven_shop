class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :current_order

  def current_order
    Order.includes(:order_items).find_by(id: session[:order_id]) || Order.new
  end

end
