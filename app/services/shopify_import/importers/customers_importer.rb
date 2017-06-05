module ShopifyImport
  module Importers
    class CustomersImporter < BaseImporter
      private

      def resources
        ShopifyImport::Customer.all(@params)
      end

      def creator
        ShopifyImport::Creators::Customer
      end
    end
  end
end
