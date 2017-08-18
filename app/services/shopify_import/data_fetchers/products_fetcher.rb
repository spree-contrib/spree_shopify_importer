module ShopifyImport
  module DataFetchers
    class ProductsFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Product.all(@params)
      end

      def job
        ShopifyImport::Importers::ProductImporterJob
      end
    end
  end
end
