def authenticate_with_shopify(shop_domain: 'example.myshopify.com', api_key: nil, password: nil)
  ShopifyAPI::Base.site = "https://#{api_key}:#{password}@#{shop_domain}/admin"
end
