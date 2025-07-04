class ::Cart::Add < Micro::Case
  attributes :params, :cart

  def call!
    @quantity = params[:quantity].to_i

    return Failure result: { message: "Invalid Cart" } unless cart

    create_cart_item
  rescue => e
    Failure result: { message: e.message }
  end

  private
  def product
    @product ||= Product.find(params[:product_id])
  end

  def cart_item
    @cart_item ||= cart&.cart_items&.find_by(product: product)
  end

  def create_cart_item
    new_cart_item = cart.cart_items.build(product: product, quantity: @quantity)

    if new_cart_item.save
      Success result: { cart: cart, message: "Product added to cart." }
    else
      Failure result: { message: new_cart_item.errors.full_messages }
    end
  end
end
