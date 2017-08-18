module ShopifyImport
  module Importers
    class TaxonImporter < BaseImporter
      private

      def creator
        ShopifyImport::Creators::TaxonCreator
      end

      def shopify_class
        ShopifyAPI::CustomCollection
      end
    end
  end
end
