module ShopifyImport
  module Creators
    class ShipmentCreator < BaseCreator
      delegate :attributes, :number, :timestamps, to: :parser

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
        @spree_shipment.update_columns(timestamps)
      end

      private

      def find_or_initialize_shipment
        @spree_shipment = @spree_order.shipments.find_or_initialize_by(number: number)
      end

      def save_shipment_with_attributes
        @spree_shipment.assign_attributes(attributes)
      end

      def assign_spree_shipment_to_data_feed
        @shopify_data_feed.update(spree_object: @spree_shipment)
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Shipments::BaseData.new(shopify_fulfillment)
      end

      def shopify_fulfillment
        @shopify_fulfillment ||= ShopifyAPI::Fulfillment.new(data_feed)
      end
    end
  end
end
