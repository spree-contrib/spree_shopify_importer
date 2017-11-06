module ShopifyImport
  module Importers
    class ProductImporterJob < ::ShopifyImportJob
      def perform(resource)
        ProductImporter.new(resource).import!
      end
    end
  end
end
