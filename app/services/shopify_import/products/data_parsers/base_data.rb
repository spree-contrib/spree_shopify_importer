module ShopifyImport
  module Products
    module DataParsers
      class BaseData
        def initialize(shopify_product)
          @shopify_product = shopify_product
        end

        def product_attributes
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

        def product_tags
          @shopify_product.tags
        end

        def option_types
          @shopify_product.options.map do |option|
            { option.name.strip.downcase => option_values(option.values) }
          end.inject(:merge)
        end

        private

        def shipping_category
          Spree::ShippingCategory.where(name: 'ShopifyImported').first_or_create
        end

        def option_values(values)
          values.map do |value|
            value.strip.downcase
          end
        end
      end
    end
  end
end
