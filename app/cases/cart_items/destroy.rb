class ::CartItems::Destroy < Micro::Case
  attributes :product_id, :cart

  def call!
    return Failure result: { message: "Cart item not found" } unless cart_item

    if cart_item.destroy
      Success result: { message: "Cart item successfully removed." }
    else
      Failure result: { message: cart_item.errors.full_messages }
    end

  rescue => e
    Failure result: { message: e.message }
  end

  private

  def cart_item
    @cart_item ||= CartItem.find_by(product_id: product_id, cart: cart)
  end
end
