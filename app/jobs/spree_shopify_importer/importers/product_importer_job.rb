module SpreeShopifyImporter
  module Importers
    class ProductImporterJob < ::SpreeShopifyImporterJob
      def perform(resource)
        ProductImporter.new(resource).import!
      end
    end
  end
end
