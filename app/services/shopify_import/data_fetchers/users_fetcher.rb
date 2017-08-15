module ShopifyImport
  module DataFetchers
    class UsersFetcher < BaseFetcher
      def import!
        resources.each do |resource|
          ShopifyImport::Importers::UserImporterJob.perform_later(resource.to_json)
        end
      end

      private

      def resources
        ShopifyImport::Customer.all(@params)
      end
    end
  end
end
