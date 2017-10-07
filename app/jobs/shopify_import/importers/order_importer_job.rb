module ShopifyImport
  module Importers
    class OrderImporterJob < ::ApplicationJob
      def perform(resource)
        OrderImporter.new(resource).import!
      end
    end
  end
end
