module ShopifyImport
  module Importers
    class UserImporter < BaseImporter
      private

      def resources
        ShopifyImport::Customer.all(@params)
      end

      def creator
        ShopifyImport::Creators::User
      end
    end
  end
end
