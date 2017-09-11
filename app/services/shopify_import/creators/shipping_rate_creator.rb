module ShopifyImport
  module Creators
    class ShippingRateCreator < BaseCreator
      delegate :attributes, to: :parser

      def initialize(shopify_shipping_line, shopify_order, spree_shipment)
        @shopify_shipping_line = shopify_shipping_line
        @shopify_order = shopify_order
        @spree_shipment = spree_shipment
      end

      def save!
        @spree_shipment.shipping_rates.create!(attributes)
      end

      private

      def parser
        @parser ||= ShopifyImport::DataParsers::ShippingRates::BaseData.new(@shopify_shipping_line, @shopify_order)
      end
    end
  end
end
