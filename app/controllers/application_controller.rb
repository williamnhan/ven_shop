class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :current_order

  def current_order
    if !session[:order_id].nil? && Order.exists?(session[:order_id])
      Order.find(session[:order_id])
    else
      Order.new
    end
  end

end
