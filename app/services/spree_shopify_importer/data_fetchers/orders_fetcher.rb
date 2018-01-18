module SpreeShopifyImporter
  module DataFetchers
    class OrdersFetcher < BaseFetcher
      private

      def resources
        SpreeShopifyImporter::Connections::Order.all(@params)
      end

      def job
        SpreeShopifyImporter::Importers::OrderImporterJob
      end
    end
  end
end
