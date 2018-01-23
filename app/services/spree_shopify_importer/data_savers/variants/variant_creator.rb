module SpreeShopifyImporter
  module DataSavers
    module Variants
      class VariantCreator < VariantBase
        def initialize(shopify_data_feed, spree_product, shopify_image = nil)
          super(shopify_data_feed)
          @spree_product = spree_product
          @shopify_image = shopify_image
        end

        def create!
          Spree::Variant.transaction do
            @spree_variant = build_spree_variant
            add_option_values
            @spree_variant.save!
            assing_spree_variant_to_data_feed
            set_stock_data
          end
          create_spree_image if @shopify_image.present?
        end

        private

        def build_spree_variant
          Spree::Variant.new(attributes)
        end
      end
    end
  end
end
