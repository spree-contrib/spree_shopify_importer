module ShopifyImport
  module Importers
    class TaxonImporter < BaseImporter
      private

      def resources
        ShopifyImport::CustomCollection.all(@params)
      end

      def creator
        ShopifyImport::Creators::Taxon
      end
    end
  end
end
