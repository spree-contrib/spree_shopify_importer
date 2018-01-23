module SpreeShopifyImporter
  module Importers
    class UserImporterJob < ::SpreeShopifyImporterJob
      def perform(resource)
        SpreeShopifyImporter::Importers::UserImporter.new(resource).import!
      end
    end
  end
end
