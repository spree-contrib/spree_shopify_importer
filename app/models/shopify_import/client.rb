require 'singleton'

module ShopifyImport
  class Client
    include Singleton
    attr_reader :site

    def get_connection(api_key: nil, password: nil, shop_name: nil)
      @api_key = api_key || Spree::Config[:shopify_api_key]
      @password = password || Spree::Config[:shopify_password]
      @shop_domain = shop_name || Spree::Config[:shopify_shop_domain]
      @site = shopify_site
    end

    private

    # TODO: ADD ERROR HANDLING TO EMPTY CREDENTIALS
    # TODO: ADD ERROR HANDLING TO INVALID CREDENTIALS
    def shopify_site
      ShopifyAPI::Base.site = "https://#{@api_key}:#{@password}@#{@shop_domain}.myshopify.com/admin"
    end
  end
end
