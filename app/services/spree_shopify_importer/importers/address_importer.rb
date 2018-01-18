module SpreeShopifyImporter
  module Importers
    class AddressImporter < BaseImporter
      def initialize(resource, spree_user)
        super(resource)
        @spree_user = spree_user
      end

      def import!
        data_feed = process_data_feed

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed, @spree_user).create!
        else
          updater.new(data_feed, spree_object).update!
        end
      end

      private

      def creator
        SpreeShopifyImporter::DataSavers::Addresses::AddressCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Addresses::AddressUpdater
      end

      def shopify_object
        ShopifyAPI::Address.new(JSON.parse(@resource))
      end
    end
  end
end
