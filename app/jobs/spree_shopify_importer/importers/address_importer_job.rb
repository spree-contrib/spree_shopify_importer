module SpreeShopifyImporter
  module Importers
    class AddressImporterJob < ::SpreeShopifyImporterJob
      def perform(resource, spree_user)
        AddressImporter.new(resource, spree_user).import!
      end
    end
  end
end
