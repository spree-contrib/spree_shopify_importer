module SpreeShopifyImporter
  module Importers
    class ImageImporterJob < ::SpreeShopifyImporterJob
      def perform(resource, parent_feed, spree_object)
        ImageImporter.new(resource, parent_feed, spree_object).import!
      end
    end
  end
end
