module ShopifyImport
  module Importers
    class ImageImporterJob < ApplicationJob
      def perform(resource, parent_feed, spree_object)
        ImageImporter.new(resource, parent_feed, spree_object).import!
      end
    end
  end
end
