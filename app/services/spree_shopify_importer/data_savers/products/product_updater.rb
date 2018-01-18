module SpreeShopifyImporter
  module DataSavers
    module Products
      class ProductUpdater < ProductBase
        def initialize(shopify_data_feed, spree_product)
          super(shopify_data_feed)
          @spree_product = spree_product
        end

        def update!
          Spree::Product.transaction do
            update_spree_product
            add_option_types
            add_tags
          end
          create_spree_variants
          create_spree_images
        end

        private

        def update_spree_product
          @spree_product.update!(attributes)
        end
      end
    end
  end
end
