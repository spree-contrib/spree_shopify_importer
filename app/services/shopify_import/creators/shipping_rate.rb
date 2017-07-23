module ShopifyImport
  module Creators
    class ShippingRate
      def initialize(shopify_shipping_line, shopify_order, spree_shipment)
        @shopify_shipping_line = shopify_shipping_line
        @shopify_order = shopify_order
        @spree_shipment = spree_shipment
      end

      def save!
        @spree_shipment.shipping_rates.create!(shipping_rate_attributes)
      end

      private

      def shipping_rate_attributes
        parser.shipping_rate_attributes
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::ShippingRates::BaseData.new(@shopify_shipping_line, @shopify_order)
      end
    end
  end
end
