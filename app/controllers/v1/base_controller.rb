class V1::BaseController < ApplicationController
  private
  def set_cart
    # Find cart_items by ID stored in session, or create a new one.
    # The session is a hash available in controllers.
    @cart ||= Cart.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create(session_id: SecureRandom.uuid) # Assign a unique session_id
      session[:cart_id] = @cart.id # Store the new cart_items's ID in the user's session
    end
  end
end
