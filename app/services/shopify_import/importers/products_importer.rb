module ShopifyImport
  module Importers
    class ProductsImporter < BaseImporter
      private

      def resources
        ShopifyImport::Product.all(@params)
      end

      def creator
        ShopifyImport::Creators::Product
      end
    end
  end
end
