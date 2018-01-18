module ShopifyImport
  module DataFetchers
    class ProductsFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Connections::Product.all(@params)
      end

      def job
        ShopifyImport::Importers::ProductImporterJob
      end
    end
  end
end
