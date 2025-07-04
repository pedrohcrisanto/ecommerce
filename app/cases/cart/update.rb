class Cart::Update < Micro::Case
  attributes :params, :cart

  def call!
    @quantity = params[:quantity].to_i

    return Failure result: { message: "Invalid Cart" } unless cart

    update_quantity
  rescue => e
    Failure result: { message: e.message }
  end

  private

  def update_quantity
    return destroy_cart_item if @quantity == 0

    cart_item&.quantity = @quantity

    if cart_item.save
      Success result: { cart: cart, message: "Product quantity updated." }
    else
      Failure result: { message: cart_item.errors.full_messages }
    end
  end

  def destroy_cart_item
    if cart_item.destroy
      Success result: { cart: cart, message: "Product removed from cart." }
    else
      Failure result: { message: cart_item.errors.full_messages }
    end
  end

  def product
    @product ||= Product.find(params[:product_id])
  end

  def cart_item
    @cart_item ||= cart.cart_items.find_by(product: product)
  end
end
