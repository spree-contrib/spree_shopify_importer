require 'singleton'

module ShopifyImport
  class Client
    include Singleton

    def get_connection(api_key: nil, password: nil, shop_domain: nil, token: nil)
      api_key ||= Spree::Config[:shopify_api_key]
      password ||= Spree::Config[:shopify_password]
      shop_domain ||= Spree::Config[:shopify_shop_domain]
      token ||= Spree::Config[:shopify_token]

      initiate_session(api_key, password, shop_domain, token)
    end

    private

    # TODO: ADD ERROR HANDLING TO EMPTY CREDENTIALS
    # TODO: ADD ERROR HANDLING TO INVALID CREDENTIALS
    def initiate_session(api_key, password, shop_domain, token)
      if password.present?
        authenticate_private_app(api_key, password, shop_domain)
      elsif token.present?
        ShopifyAPI::Session.new(shop_domain, token)
      else
        raise I18n.t('shopify_import.client.missing_credentials')
      end
    end

    def authenticate_private_app(api_key, password, shop_domain)
      ShopifyAPI::Base.site = "https://#{api_key}:#{password}@#{shop_domain}/admin"
    end
  end
end
