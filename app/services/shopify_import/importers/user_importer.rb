module ShopifyImport
  module Importers
    class UserImporter < BaseImporter
      private

      def creator
        ShopifyImport::DataSavers::Users::UserCreator
      end

      def updater
        ShopifyImport::DataSavers::Users::UserUpdater
      end

      def shopify_class
        ShopifyAPI::Customer
      end
    end
  end
end
