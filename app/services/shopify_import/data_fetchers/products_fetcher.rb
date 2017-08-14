module ShopifyImport
  module DataFetchers
    class ProductsFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Product.all(@params)
      end

      def creator
        ShopifyImport::Creators::ProductCreator
      end
    end
  end
end
