module ShopifyImport
  module DataFetchers
    class TaxonsFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Connections::CustomCollection.all(@params)
      end

      def job
        ShopifyImport::Importers::TaxonImporterJob
      end
    end
  end
end
