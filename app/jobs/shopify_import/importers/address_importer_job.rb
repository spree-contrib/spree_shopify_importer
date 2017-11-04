module ShopifyImport
  module Importers
    class AddressImporterJob < ::ShopifyImportJob
      def perform(resource, spree_user)
        AddressImporter.new(resource, spree_user).import!
      end
    end
  end
end
