module ShopifyImport
  module Importers
    class TaxonImporter < BaseImporter
      private

      def creator
        ShopifyImport::DataSavers::Taxons::TaxonCreator
      end

      def updater
        ShopifyImport::DataSavers::Taxons::TaxonUpdater
      end

      def shopify_class
        ShopifyAPI::CustomCollection
      end
    end
  end
end
