module ShopifyImport
  module Importers
    class ShipmentImporter
      def initialize(fulfillment, parent_feed, spree_order)
        @fulfillment = fulfillment
        @parent_feed = parent_feed
        @spree_order = spree_order
      end

      def import!
        feed = ((old_data_feed = find_existing_data_feed).blank? ? create_data_feed : update_data_feed(old_data_feed))

        creator.new(feed, @parent_feed, @spree_order).create!
      end

      private

      def find_existing_data_feed
        Shopify::DataFeed.find_by(shopify_object_id: @fulfillment.id, shopify_object_type: @fulfillment.class.to_s)
      end

      def create_data_feed
        Shopify::DataFeeds::Create.new(@fulfillment, @parent_feed).save!
      end

      def update_data_feed(old_data_feed)
        Shopify::DataFeeds::Update.new(old_data_feed, @fulfillment, @parent_feed).update!
      end

      def creator
        ShopifyImport::DataSavers::Shipments::ShipmentCreator
      end
    end
  end
end
