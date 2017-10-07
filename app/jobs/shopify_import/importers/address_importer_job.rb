module ShopifyImport
  module Importers
    class AddressImporterJob < ::ApplicationJob
      def perform(resource, spree_user)
        AddressImporter.new(resource, spree_user).import!
      end
    end
  end
end
