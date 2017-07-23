module ShopifyImport
  module Importers
    class ProductsImporter < BaseImporter
      private

      def resources
        ShopifyImport::Product.all(@params)
      end

      def creator
        ShopifyImport::Creators::ProductCreator
      end
    end
  end
end
