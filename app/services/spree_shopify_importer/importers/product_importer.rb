module SpreeShopifyImporter
  module Importers
    class ProductImporter < BaseImporter
      private

      def creator
        SpreeShopifyImporter::DataSavers::Products::ProductCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Products::ProductUpdater
      end

      def shopify_class
        ShopifyAPI::Product
      end
    end
  end
end
