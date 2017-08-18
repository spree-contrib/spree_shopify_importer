module ShopifyImport
  module DataFetchers
    class TaxonsFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::CustomCollection.all(@params)
      end

      def job
        ShopifyImport::Importers::TaxonImporterJob
      end
    end
  end
end
