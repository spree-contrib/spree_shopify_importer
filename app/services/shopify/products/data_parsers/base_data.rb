module Shopify
  module Products
    module DataParsers
      class BaseData
        def self.prepare_data(shopify_product)
          new(shopify_product).send(:create_data_hash)
        end

        def initialize(shopify_product)
          @shopify_product = shopify_product
        end

        private

        def create_data_hash
          {
            name: @shopify_product.title,
            description: @shopify_product.body_html,
            available_on: @shopify_product.published_at,
            slug: @shopify_product.handle,
            price: 0, # TODO
            created_at: @shopify_product.created_at,
            shipping_category: shipping_category # TODO
          }
        end

        def shipping_category
          Spree::ShippingCategory.where(name: 'ShopifyImported').first_or_create
        end
      end
    end
  end
end
