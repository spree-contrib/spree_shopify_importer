module Shopify
  module Products
    module Imports
      class Create
        def initialize(shopify_data_feed)
          @shopify_data_feed = shopify_data_feed
        end

        def save!
          Spree::Product.transaction do
            @spree_product = create_spree_product
            assign_data_feed_to_product
            add_tags
          end
        end

        private

        def create_spree_product
          Spree::Product.create!(product_attributes)
        end

        def assign_data_feed_to_product
          @shopify_data_feed.update!(spree_object: @spree_product)
        end

        def add_tags
          return unless @spree_product.respond_to?(:tag_list)

          @spree_product.tag_list.add(shopify_product.tags, parse: true)
          @spree_product.save!
        end

        def product_attributes
          Shopify::Products::DataParsers::BaseData.prepare_data(shopify_product)
        end

        def shopify_product
          @shopify_product ||= ShopifyAPI::Product.new(JSON.parse(@shopify_data_feed.data_feed))
        end

        def shipping_category
          Spree::ShippingCategory.where(name: 'ShopifyImported').first_or_create
        end
      end
    end
  end
end
