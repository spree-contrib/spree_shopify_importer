module ShopifyImport
  class Invoker
    ROOT_FETCHERS = [
      ShopifyImport::DataFetchers::ProductsFetcher,
      ShopifyImport::DataFetchers::UsersFetcher,
      ShopifyImport::DataFetchers::TaxonsFetcher
    ].freeze

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

    # TODO: custom params for importers
    def initiate_import!
      ROOT_FETCHERS.each do |importer|
        importer.new.import!
      end
    end
  end
end
