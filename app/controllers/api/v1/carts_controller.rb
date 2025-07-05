class ::Api::V1::CartsController < ::Api::V1::BaseController
  def create
    result = ::Cart::AddItem.call(params: cart_params, cart: current_cart)

    if result.success?
      render json: { data: CartBlueprint.render_as_json(current_cart), message: result.data[:message] }, status: :created
    else
      render json: { message: result.data[:message] }, status: :unprocessable_entity
    end
  end

  def show
    render json: CartBlueprint.render_as_json(current_cart), status: :ok
  end

  def destroy
    result = ::Cart::Destroy.call(product_id: cart_params[:product_id], cart: current_cart)

    if result.success?
      @cart.reload # Reload cart to reflect items removal and update total_price
      render json: { data: CartBlueprint.render_as_json(current_cart), message: result.data[:message] }, status: :ok
    else
      render json: { message: result.data[:message] }, status: :unprocessable_entity
    end
  end

  def update
    result = ::Cart::Update.call(params: cart_params, cart: current_cart)

    if result.success?
      current_cart.reload # Reload cart to reflect updated quantities and total_price
      render json: { data: CartBlueprint.render_as_json(current_cart), message: result.data[:message] }, status: :ok
    else
      render json: { message: result.data[:message] }, status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end
end
