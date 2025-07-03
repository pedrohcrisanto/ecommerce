class Products::Repository
  ALL_PRODUCTS = "all_products".freeze
  def self.call
    new

    all
  end

  def all
    Rails.cache.fetch(ALL_PRODUCTS, expires_in: 1.hour) do
      Product.all
    end
  end
end
