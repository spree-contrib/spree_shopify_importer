module ShopifyImport
  module Importers
    class VariantImporterJob < ::ApplicationJob
      def perform(resource, parent_feed, spree_product, shopify_image = nil)
        VariantImporter.new(resource, parent_feed, spree_product, shopify_image).import!
      end
    end
  end
end
