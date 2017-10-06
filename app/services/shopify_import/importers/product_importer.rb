module ShopifyImport
  module Importers
    class ProductImporter < BaseImporter
      private

      def creator
        ShopifyImport::DataSavers::Products::ProductCreator
      end

      def updater
        ShopifyImport::DataSavers::Products::ProductUpdater
      end

      def shopify_class
        ShopifyAPI::Product
      end
    end
  end
end
