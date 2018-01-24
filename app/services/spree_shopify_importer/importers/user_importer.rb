module SpreeShopifyImporter
  module Importers
    class UserImporter < BaseImporter
      def import!
        data_feed = process_data_feed
        return if shopify_object.email.blank?

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed).create!
        else
          updater.new(data_feed, spree_object).update!
        end
      end

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
