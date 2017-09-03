module ShopifyImport
  module Creators
    class VariantCreator < BaseCreator
      delegate :attributes, :option_value_ids, :track_inventory?,
               :backorderable?, :stock_location, :inventory_quantity, to: :parser

      def initialize(shopify_data_feed, spree_product, shopify_image = nil)
        super(shopify_data_feed)
        @spree_product = spree_product
        @shopify_image = shopify_image
      end

      def save!
        Spree::Variant.transaction do
          @spree_variant = build_spree_variant
          add_option_values
          @spree_variant.save!
          set_stock_data
        end
        create_spree_image if @shopify_image.present?
      end

      private

      def build_spree_variant
        Spree::Variant.new(attributes)
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

      def create_spree_image
        ShopifyImport::Importers::ImageImporterJob.perform_later(@shopify_image, @shopify_data_feed, @spree_variant)
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Variants::BaseData.new(shopify_variant, @spree_product)
      end

      def shopify_variant
        ShopifyAPI::Variant.new(data_feed)
      end
    end
  end
end
