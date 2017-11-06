module ShopifyImport
  module Importers
    class OrderImporterJob < ::ShopifyImportJob
      def perform(resource)
        OrderImporter.new(resource).import!
      end
    end
  end
end
