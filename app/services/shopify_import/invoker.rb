module ShopifyImport
  class Invoker
    def initialize(credentials: nil)
      @credentials = credentials
      @credentials ||= {
        api_key: Spree::Config[:shopify_api_key],
        password: Spree::Config[:shopify_password],
        shop_domain: Spree::Config[:shopify_shop_domain],
        token: Spree::Config[:shopify_token]
      }
    end

    def import!
      connect

      initiate_import!
    end

    private

    def connect
      ShopifyImport::Client.instance.get_connection(@credentials)
    end

    def initiate_import!
      ShopifyImport::Importers::ProductsImporter.new.import!
      ShopifyImport::Importers::CustomersImporter.new.import!
    end
  end
end
