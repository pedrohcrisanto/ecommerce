class ::CartItems::Create < Micro::Case
  attributes :params, :cart

  def call!
    @product = Product.all.find(params[:product_id])
    @quantity = params[:quantity].to_i
    @cart_item = cart&.cart_items&.find_by(product: @product)

    return Failure result: { message: "Invalid Product" } unless @product.present?
    return Failure result: { message: "Invalid Quantity" } unless params[:quantity].is_a?(Integer) && params[:quantity] > 0
    return Failure result: { message: "Invalid Cart" } unless cart

    @cart_item.present? ? update_quantity : create_cart_item

  rescue => e
    Failure result: { message: e.message }
  end

  private

  def update_quantity
    @cart_item&.quantity = @quantity

    if @cart_item.save
      Success result: { cart: cart, message: "Product quantity updated." }
    else
      Failure result: { message: cart_item.errors.full_messages }
    end
  end

  def create_cart_item
    new_cart_item = cart.cart_items.build(product: @product, quantity: @quantity)

    if new_cart_item.save
      Success result: { cart: cart, message: "Product added to cart_items." }
    else
      Failure result: { message: new_cart_item.errors.full_messages }
    end
  end
end
