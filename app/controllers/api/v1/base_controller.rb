class Api::V1::BaseController < ApplicationController
  before_action :set_cart

  def current_cart
    @current_cart ||= @cart
  end

  private

  def set_cart
    @cart ||= Cart.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create(session_id: SecureRandom.uuid)
      session[:cart_id] = @cart.id
    end
  end
end
