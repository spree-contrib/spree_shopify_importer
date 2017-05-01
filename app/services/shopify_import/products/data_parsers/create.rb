module ShopifyImport
  module Products
    module DataParsers
      class Create
        def self.to_spree(shopify_product)
          new(shopify_product).create_data_hash
        end

        def initialize(shopify_product)
          @shopify_product = shopify_product
        end

        def create_data_hash
          {
            name: @shopify_product.title,
            description: @shopify_product.body_html,
            available_on: @shopify_product.published_at,
            slug: @shopify_product.handle,
            price: 0, # TODO: PRODUCT MASTER VARIANT PRICE
            created_at: @shopify_product.created_at,
            shipping_category: shipping_category # TODO: DEFAULT SHIPPING CATEGORY
          }
        end

        private

        def shipping_category
          Spree::ShippingCategory.where(name: 'ShopifyImported').first_or_create
        end
      end
    end
  end
end
