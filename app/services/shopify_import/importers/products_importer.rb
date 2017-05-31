module ShopifyImport
  module Importers
    class ProductsImporter < BaseImporter
      private

      def resources
        ShopifyImport::Product.new(credentials: @credentials).find_all(@params)
      end

      def creator
        ShopifyImport::Creators::Product
      end
    end
  end
end
