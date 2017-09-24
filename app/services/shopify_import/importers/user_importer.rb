module ShopifyImport
  module Importers
    class UserImporter < BaseImporter
      def import!
        data_feed = process_data_feed

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed).create!
        else
          updater.new(data_feed, spree_object).update!
        end
      end

      private

      def process_data_feed
        (old_data_feed = find_existing_data_feed).blank? ? create_data_feed : update_data_feed(old_data_feed)
      end

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
