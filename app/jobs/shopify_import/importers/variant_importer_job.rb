module ShopifyImport
  module Importers
    class VariantImporterJob < ApplicationJob
      def perform(resource, parent_feed, spree_product)
        VariantImporter.new(resource, parent_feed, spree_product).import!
      end
    end
  end
end
