module ShopifyImport
  module DataParsers
    module CustomCollections
      class BaseData
        def initialize(shopify_custom_collection)
          @shopify_custom_collection = shopify_custom_collection
        end

        def taxon_attributes
          {
            name: @shopify_custom_collection.title,
            permalink: @shopify_custom_collection.handle,
            description: @shopify_custom_collection.body_html
          }
        end

        def product_ids
          ids = @shopify_custom_collection.products.map(&:id)

          Shopify::DataFeed
            .where(shopify_object_id: ids, shopify_object_type: 'ShopifyAPI::Product')
            .pluck(:spree_object_id)
        end
      end
    end
  end
end
