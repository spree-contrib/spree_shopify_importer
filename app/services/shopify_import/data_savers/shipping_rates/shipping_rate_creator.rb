module ShopifyImport
  module DataSavers
    module ShippingRates
      class ShippingRateCreator < BaseDataSaver
        delegate :attributes, to: :parser

        def initialize(shopify_shipping_line, shopify_order, spree_shipment)
          @shopify_shipping_line = shopify_shipping_line
          @shopify_order = shopify_order
          @spree_shipment = spree_shipment
        end

        def create!
          @spree_shipment.shipping_rates.create!(attributes)
        end

        private

        def parser
          @parser ||= ShopifyImport::DataParsers::ShippingRates::BaseData.new(@shopify_shipping_line, @shopify_order)
        end
      end
    end
  end
end
