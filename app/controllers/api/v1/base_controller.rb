class Api::V1::BaseController < ApplicationController
  before_action :set_cart

  def current_cart
    # Returns the current cart instance variable.
    @current_cart ||= @cart
  end

  private

  # This method sets the @cart instance variable.
  # It finds the cart by the ID stored in the session or creates a new one if it doesn't exist.
  # The session is a hash available in controllers, allowing us to store user-specific data.
  def set_cart
    # Find cart by ID stored in session, or create a new one.
    # The session is a hash available in controllers.
    @cart ||= Cart.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create(session_id: SecureRandom.uuid) # Assign a unique session_id
      session[:cart_id] = @cart.id # Store the new cart's ID in the user's session
    end
  end
end
