module ShopifyImport
  module Importers
    class UserImporter < BaseImporter
      private

      def creator
        ShopifyImport::Creators::UserCreator
      end

      def shopify_class
        ShopifyAPI::Customer
      end
    end
  end
end
