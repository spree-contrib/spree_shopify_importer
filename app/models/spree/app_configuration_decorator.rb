Spree::AppConfiguration.class_eval do
  preference :shopify_api_key, :string
  preference :shopify_password, :string
  preference :shopify_shop_domain, :string
  preference :shopify_token, :string
  preference :shopify_rescue_limit, :integer, default: 5
end
