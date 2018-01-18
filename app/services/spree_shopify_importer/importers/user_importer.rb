module SpreeShopifyImporter
  module Importers
    class UserImporter < BaseImporter
      private

      def creator
        SpreeShopifyImporter::DataSavers::Users::UserCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Users::UserUpdater
      end

      def shopify_class
        ShopifyAPI::Customer
      end
    end
  end
end
