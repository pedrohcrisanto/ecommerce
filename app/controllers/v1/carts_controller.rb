class V1::CartsController < BaseController
  # This makes the set_cart method run before specific actions.
  # It ensures @cart is available and handles creating a cart if it doesn't exist in the session.
  before_action :set_cart, only: [:add_item, :show, :update_item_quantity, :remove_item]
  # This skips CSRF token verification for API requests (important for non-browser clients)

  # POST /cart
  # Adds a product to the cart or updates its quantity if it already exists.
  def create
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    # Basic validations for incoming parameters
    return render json: { error: 'Product ID is required' }, status: :bad_request if product_id.zero?
    return render json: { error: 'Quantity must be a positive integer' }, status: :bad_request unless quantity > 0

    # Find the product
    product = Product.find_by(id: product_id)
    return render json: { error: 'Product not found' }, status: :not_found unless product

    # Find or initialize cart item
    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)

    if cart_item.new_record?
      cart_item.quantity = quantity
      cart_item.unit_price = product.unit_price # Store current unit price
    else
      # If item exists, add to its current quantity
      cart_item.quantity += quantity
    end

    if cart_item.save
      # Mark cart as not abandoned on interaction
      @cart.update(abandoned_at: nil) if @cart.abandoned?
      render json: cart_payload(@cart), status: :created
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /cart
  # Lists all items in the current cart.
  def show
    render json: cart_payload(@cart), status: :ok
  end

  # PATCH /cart/add_item
  # Explicitly alters the quantity of an existing product in the cart.
  # If quantity is 0, the item will be removed.
  def update_item_quantity
    product_id = params[:product_id].to_i
    new_quantity = params[:quantity].to_i

    # Basic validations for incoming parameters
    return render json: { error: 'Product ID is required' }, status: :bad_request if product_id.zero?
    return render json: { error: 'Quantity must be a non-negative integer' }, status: :bad_request unless new_quantity >= 0

    cart_item = @cart.cart_items.find_by(product_id: product_id)

    return render json: { error: 'Product not found in cart' }, status: :not_found unless cart_item

    if new_quantity.zero?
      # If new quantity is 0, remove the item
      cart_item.destroy
      @cart.reload # Reload cart to reflect item removal and update total_price
      message = "Product removed from cart."
    else
      # Update quantity
      cart_item.quantity = new_quantity
      if cart_item.save
        message = "Product quantity updated."
      else
        return render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Mark cart as not abandoned on interaction
    @cart.update(abandoned_at: nil) if @cart.abandoned?
    render json: cart_payload(@cart), status: :ok
  end


  # DELETE /cart/:product_id
  # Removes a product from the cart.
  def remove_item
    product_id = params[:product_id].to_i

    cart_item = @cart.cart_items.find_by(product_id: product_id)

    return render json: { error: 'Product not found in cart' }, status: :not_found unless cart_item

    if cart_item.destroy
      @cart.reload # Reload the cart to ensure total_price is updated after item removal
      # Mark cart as not abandoned on interaction
      @cart.update(abandoned_at: nil) if @cart.abandoned?
      render json: cart_payload(@cart), status: :ok
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Helper method to get the current cart from the session or create a new one.
  def set_cart
    # Find cart by ID stored in session, or create a new one.
    # The session is a hash available in controllers.
    @cart = Cart.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create(session_id: SecureRandom.uuid) # Assign a unique session_id
      session[:cart_id] = @cart.id # Store the new cart's ID in the user's session
    end
  end

  # Helper method to format the cart response payload consistently
  def cart_payload(cart)
    {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product_id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.unit_price.to_f, # Ensure float for JSON
          total_price: item.total_price.to_f # Ensure float for JSON
        }
      end,
      total_price: cart.total_price.to_f # Ensure float for JSON
    }
  end
end