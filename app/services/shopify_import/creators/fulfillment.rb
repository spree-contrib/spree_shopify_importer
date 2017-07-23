module ShopifyImport
  module Creators
    class Fulfillment < ShopifyImport::Creators::Base
      def initialize(shopify_data_feed, spree_order)
        super(shopify_data_feed)
        @spree_order = spree_order
      end

      def save!
        Spree::Shipment.transaction do
          find_or_initialize_shipment
          save_shipment_with_attributes
          assign_spree_shipment_to_data_feed
        end
        @spree_shipment.update_columns(shipment_timestamps)
      end

      private

      def find_or_initialize_shipment
        @spree_shipment = @spree_order.shipments.find_or_initialize_by(number: number)
      end

      def save_shipment_with_attributes
        @spree_shipment.assign_attributes(shipment_attributes)
      end

      def assign_spree_shipment_to_data_feed
        @shopify_data_feed.update(spree_object: @spree_shipment)
      end

      def shipment_timestamps
        parser.shipment_timestamps
      end

      def shipment_attributes
        parser.shipment_attributes
      end

      def number
        parser.shipment_number
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Fulfillments::BaseData.new(shopify_fulfillment)
      end

      def shopify_fulfillment
        @shopify_fulfillment ||= ShopifyAPI::Fulfillment.new(data_feed)
      end
    end
  end
end
