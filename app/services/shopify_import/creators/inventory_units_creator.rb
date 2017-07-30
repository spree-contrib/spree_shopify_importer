module ShopifyImport
  module Creators
    class InventoryUnitsCreator
      def initialize(shopify_line_item, spree_shipment)
        @shopify_line_item = shopify_line_item
        @spree_shipment = spree_shipment
      end

      def save!
        Spree::InventoryUnit.transaction do
          @shopify_line_item.quantity.times do
            create_inventory_unit
          end
        end
      end

      def create_inventory_unit
        @spree_shipment.inventory_units.create!(inventory_unit_attributes)
      end

      def inventory_unit_attributes
        @inventory_unit_attributes ||= parser.inventory_unit_attributes
      end

      def line_item
        @line_item ||= @parser.line_item
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::InventoryUnits::BaseData.new(@shopify_line_item, @spree_shipment)
      end
    end
  end
end
