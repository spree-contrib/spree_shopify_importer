module ShopifyImport
  class Invoker
    def initialize(credentials: nil)
      @credentials = credentials
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
    end
  end
end
