module SpreeShopifyImporter
  module Importers
    class OrderImporterJob < ::SpreeShopifyImporterJob
      def perform(resource)
        OrderImporter.new(resource).import!
      end
    end
  end
end
