module SpreeShopifyImporter
  module Importers
    class TaxonImporter < BaseImporter
      private

      def creator
        SpreeShopifyImporter::DataSavers::Taxons::TaxonCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Taxons::TaxonUpdater
      end

      def shopify_class
        ShopifyAPI::CustomCollection
      end
    end
  end
end
