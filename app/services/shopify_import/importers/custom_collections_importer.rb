module ShopifyImport
  module Importers
    class CustomCollectionsImporter < BaseImporter
      private

      def resources
        ShopifyImport::CustomCollection.all(@params)
      end

      def creator
        ShopifyImport::Creators::CustomCollection
      end
    end
  end
end
