def authenticate_with_shopify(
  api_key: '0a9445b7b067719a0af024610364ee34', password: '800f97d6ea1a768048851cdd99a9101a',
  shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
)
  ShopifyAPI::Base.site = "https://#{api_key}:#{password}@#{shop_domain}/admin"
end
