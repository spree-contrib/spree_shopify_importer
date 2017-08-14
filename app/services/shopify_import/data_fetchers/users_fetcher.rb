module ShopifyImport
  module DataFetchers
    class UsersFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Customer.all(@params)
      end

      def creator
        ShopifyImport::Creators::UserCreator
      end
    end
  end
end
