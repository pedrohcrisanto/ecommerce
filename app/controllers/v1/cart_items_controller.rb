class V1::CartItemsController < BaseController
  def create
    result = ::CartItem::Create.call(params: { product_id: cart_params[:product_id],
                                               quantity: cart_params[:quantity] }, cart: @cart)

    if result.success?
      render json: cart_payload(@cart), status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: cart_payload(@cart), status: :ok
  end

  def destroy
    result = ::CartItem::Destroy.call(product_id: cart_params[:product_id])

    if result.success?
      @cart.reload # Reload cart_items to reflect items removal and update total_price
      render json: cart_payload(@cart), status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  # Helper method to format the cart_items response payload consistently
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

  def cart_params
    params.permit.require(:product_id, :quantity)
  end
end
