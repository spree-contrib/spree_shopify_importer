module ShopifyImport
  module Importers
    class TaxonImporterJob < ::ShopifyImportJob
      def perform(resource)
        ShopifyImport::Importers::TaxonImporter.new(resource).import!
      end
    end
  end
end
