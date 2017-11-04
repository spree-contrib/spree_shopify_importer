module ShopifyImport
  module Importers
    class UserImporterJob < ::ShopifyImportJob
      def perform(resource)
        ShopifyImport::Importers::UserImporter.new(resource).import!
      end
    end
  end
end
