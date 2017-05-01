module ShopifyImport
  module Importers
    class ProductsImporter < BaseImporter
      private

      def resources
        ShopifyImport::Product.new(credentials: @credentials).find_all(@params)
      end

      def creator
        ShopifyImport::Products::Create
      end
    end
  end
end
