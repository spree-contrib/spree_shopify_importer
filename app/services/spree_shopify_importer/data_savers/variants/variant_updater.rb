module SpreeShopifyImporter
  module DataSavers
    module Variants
      class VariantUpdater < VariantBase
        def initialize(shopify_data_feed, spree_variant, spree_product, shopify_image = nil)
          super(shopify_data_feed)
          @spree_variant = spree_variant
          @spree_product = spree_product
          @shopify_image = shopify_image
        end

        def update!
          Spree::Variant.transaction do
            update_spree_variant
            add_option_values
            @spree_variant.save!
            set_stock_data
          end
          create_spree_image if @shopify_image.present?
        end

        private

        def update_spree_variant
          @spree_variant.update!(attributes)
        end
      end
    end
  end
end
