require 'singleton'

module ShopifyImport
  module Connections
    class ClientError < StandardError; end

    class Client
      include Singleton
      attr_reader :connection

      # Authenticates to Shopify as either a Shopify app with oauth token or a private app
      # This method can raise various ActiveResource errors:
      # https://github.com/rails/activeresource/blob/f8abaf13174e94d179227f352c9dd6fb8b03e0da/lib/active_resource/exceptions.rb
      # ActiveResource::ConnectionError
      # ActiveResource::TimeoutError
      # ActiveResource::SSLError
      # ActiveResource::Redirection < ConnectionError
      # ActiveResource::MissingPrefixParam
      # ActiveResource::ClientError < ConnectionError
      # ActiveResource::BadRequest < ClientError
      # ActiveResource::UnauthorizedAccess < ClientError - on invalid password, invalid auth token or invalid domain
      # ActiveResource::ForbiddenAccess < ClientError    - on invalid api_key
      # ActiveResource::ResourceNotFound < ClientError   - on invalid API endpoint
      # ActiveResource::ResourceConflict < ClientError
      # ActiveResource::ResourceGone < ClientError
      # ActiveResource::ServerError < ConnectionError
      # ActiveResource::MethodNotAllowed < ClientError
      def get_connection(api_key: nil, password: nil, shop_domain: nil, token: nil)
        if api_key.present? && password.present?
          @connection = ShopifyAPI::Base.site = "https://#{api_key}:#{password}@#{shop_domain}/admin"
        elsif token.present?
          session = ShopifyAPI::Session.new(shop_domain, token)
          @connection = ShopifyAPI::Base.activate_session(session)
        else
          raise ShopifyImport::Connections::ClientError, I18n.t('shopify_import.client.missing_credentials')
        end

        # the above code doesn't make the call to Shopify to authenticate, so we have to make a call manually
        ShopifyAPI::Shop.current
      end
    end
  end
end
