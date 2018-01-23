module SpreeShopifyImporter
  module DataFetchers
    class UsersFetcher < BaseFetcher
      private

      def resources
        SpreeShopifyImporter::Connections::Customer.all(@params)
      end

      def job
        SpreeShopifyImporter::Importers::UserImporterJob
      end
    end
  end
end
