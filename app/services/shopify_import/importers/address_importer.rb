module ShopifyImport
  module Importers
    class AddressImporter
      def initialize(resource, spree_user)
        @resource = resource
        @spree_user = spree_user
      end

      def import!
        data_feed = create_data_feed
        ShopifyImport::Creators::AddressCreator.new(data_feed, @spree_user).save!
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(shopify_object).save!
      end

      def shopify_object
        ShopifyAPI::Address.new(JSON.parse(@resource))
      end
    end
  end
end
