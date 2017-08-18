module ShopifyImport
  module DataFetchers
    class UsersFetcher < BaseFetcher
      private

      def resources
        ShopifyImport::Customer.all(@params)
      end

      def job
        ShopifyImport::Importers::UserImporterJob
      end
    end
  end
end
