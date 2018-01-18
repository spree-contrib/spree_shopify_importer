module SpreeShopifyImporter
  module Importers
    class TaxonImporterJob < ::SpreeShopifyImporterJob
      def perform(resource)
        SpreeShopifyImporter::Importers::TaxonImporter.new(resource).import!
      end
    end
  end
end
