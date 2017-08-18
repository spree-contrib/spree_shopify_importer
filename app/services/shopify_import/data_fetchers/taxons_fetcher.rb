module ShopifyImport
  module DataFetchers
    class TaxonsFetcher < BaseFetcher
      def import!
        resources.each do |resource|
          ShopifyImport::Importers::TaxonImporterJob.perform_later(resource.to_json)
        end
      end

      private

      def resources
        ShopifyImport::CustomCollection.all(@params)
      end
    end
  end
end
