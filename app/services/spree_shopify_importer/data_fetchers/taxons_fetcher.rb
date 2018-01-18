module SpreeShopifyImporter
  module DataFetchers
    class TaxonsFetcher < BaseFetcher
      private

      def resources
        SpreeShopifyImporter::Connections::CustomCollection.all(@params)
      end

      def job
        SpreeShopifyImporter::Importers::TaxonImporterJob
      end
    end
  end
end
