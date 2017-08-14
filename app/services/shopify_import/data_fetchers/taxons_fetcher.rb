module ShopifyImport
  module DataFetchers
    class TaxonsFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::CustomCollection.all(@params)
      end

      def creator
        ShopifyImport::Creators::TaxonCreator
      end
    end
  end
end
