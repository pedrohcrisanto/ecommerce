class ::CartItems::Destroy < Micro::Case
  attributes :product_id

  def call!
    return Failure(:cart_item_not_found) unless cart_item

    if cart_item.destroy
      Success result: { message: "Cart item successfully removed." }
    else
      Failure(:cart_item_not_destroyed, result: { errors: cart_item.errors.full_messages })
    end
  end

  private

  def cart_item
    @cart_item ||= CartItem.find_by(product_id: product_id)
  end
end
