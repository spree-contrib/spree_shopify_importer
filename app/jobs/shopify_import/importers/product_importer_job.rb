module ShopifyImport
  module Importers
    class ProductImporterJob < ApplicationJob
      def perform(resource)
        ProductImporter.new(resource).import!
      end
    end
  end
end
