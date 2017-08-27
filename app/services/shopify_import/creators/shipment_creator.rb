module ShopifyImport
  module Creators
    class ShipmentCreator < BaseCreator
      delegate :attributes, :number, :timestamps, to: :parser

      def initialize(shopify_data_feed, parent_feed, spree_order)
        super(shopify_data_feed)
        @parent_feed = parent_feed # shopify order data feed
        @spree_order = spree_order
      end

      def save!
        Spree::Shipment.transaction do
          find_or_initialize_shipment
          save_shipment_with_attributes
          create_shipping_rate
          # TODO: create inventory units
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
        @spree_shipment.save!(validate: false)
      end

      def assign_spree_shipment_to_data_feed
        @shopify_data_feed.update(spree_object: @spree_shipment)
      end

      def create_shipping_rate
        ShopifyImport::Creators::ShippingRateCreator.new(shopify_shipping_line, shopify_order, @spree_shipment).save!
      end

      def shopify_shipping_line
        shopify_order.shipping_lines.first
      end

      def shopify_order
        ShopifyAPI::Order.new(JSON.parse(@parent_feed.data_feed))
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
