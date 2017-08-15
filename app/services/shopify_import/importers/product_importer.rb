module ShopifyImport
  module Importers
    class ProductImporter < BaseImporter
      private

      def creator
        ShopifyImport::Creators::ProductCreator
      end

      def shopify_class
        ShopifyAPI::Product
      end
    end
  end
end
