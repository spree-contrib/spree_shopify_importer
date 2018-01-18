module SpreeShopifyImporter
  module Importers
    class ShipmentImporter < BaseImporter
      def initialize(fulfillment, parent_feed, spree_order)
        @fulfillment = fulfillment
        @parent_feed = parent_feed
        @spree_order = spree_order
      end

      def import!
        data_feed = process_data_feed

        creator.new(data_feed, @parent_feed, @spree_order).create!
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(@fulfillment, @parent_feed).save!
      end

      def update_data_feed(old_data_feed)
        Shopify::DataFeeds::Update.new(old_data_feed, @fulfillment, @parent_feed).update!
      end

      def creator
        SpreeShopifyImporter::DataSavers::Shipments::ShipmentCreator
      end

      def shopify_object
        @fulfillment
      end
    end
  end
end
