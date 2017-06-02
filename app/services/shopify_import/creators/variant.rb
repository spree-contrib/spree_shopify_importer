module ShopifyImport
  module Creators
    class Variant
      def initialize(shopify_variant, spree_product)
        @shopify_variant = shopify_variant
        @spree_product = spree_product
      end

      def save!
        Spree::Variant.transaction do
          @spree_variant = build_spree_variant
          add_option_values
          @spree_variant.save!
          set_stock_data
        end
      end

      private

      def build_spree_variant
        Spree::Variant.new(parser.variant_attributes)
      end

      def add_option_values
        @spree_variant.assign_attributes(option_value_ids: parser.option_value_ids)
      end

      def set_stock_data
        @spree_variant.update(track_inventory: track_inventory?)
        stock_item = @spree_variant.stock_items.find_by(stock_location: stock_location)
        stock_item.update(backorderable: backorderable?)
        stock_item.set_count_on_hand(inventory_quantity) if track_inventory?
      end

      def track_inventory?
        @track_inventory ||= parser.track_inventory?
      end

      def backorderable?
        @backorderable ||= parser.backorderable?
      end

      def stock_location
        @stock_location ||= parser.stock_location
      end

      def inventory_quantity
        @inventory_quantity ||= parser.inventory_quantity
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Variants::BaseData.new(@shopify_variant, @spree_product)
      end
    end
  end
end
