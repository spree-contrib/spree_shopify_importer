module ShopifyImport
  module DataFetchers
    class OrdersFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Order.all(@params)
      end

      def job
        ShopifyImport::Importers::OrderImporterJob
      end
    end
  end
end
