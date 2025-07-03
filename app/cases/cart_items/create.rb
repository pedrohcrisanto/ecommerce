class ::CartItems::Create < Micro::Case
  attributes :params, :cart

  def call!
    @product = Product::Repository.call.find(params[:product_id])
    @quantity = params[:quantity].to_i
    @cart_item = cart.cart_items.find_by(product: @product)

    return Failure(:invalid_product_id) unless @product.exists?
    return Failure(:invalid_quantity) unless quantity.is_a?(Integer) && quantity > 0
    return Failure(:cart_not_found) unless cart

    @cart_item.exists? ? update_quantity : create_cart_item
  end

  private

  def update_quantity
    @cart_item.quantity = quantity

    if @cart_item.save
      Success result: { cart: cart, message: "Product quantity updated." }
    else
      Failure(:update_failed, errors: cart_item.errors.full_messages)
    end
  end

  def create_cart_item
    new_cart_item = cart.cart_items.build(product: @product, quantity: @quantity)

    if new_cart_item.save
      Success result: { cart: cart, message: "Product added to cart_items." }
    else
      Failure(:creation_failed, errors: new_cart_item.errors.full_messages)
    end
  end
end
