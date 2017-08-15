module ShopifyImport
  module DataFetchers
    class ProductsFetcher < BaseFetcher
      def import!
        resources.each do |resource|
          ShopifyImport::Importers::ProductImporterJob.perform_later(resource.to_json)
        end
      end

      private

      def resources
        ShopifyImport::Product.all(@params)
      end
    end
  end
end
