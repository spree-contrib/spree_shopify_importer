module SpreeShopifyImporter
  module DataParsers
    module Taxons
      class BaseData
        def initialize(shopify_custom_collection)
          @shopify_custom_collection = shopify_custom_collection
        end

        def attributes
          @attributes ||= {
            name: @shopify_custom_collection.title,
            permalink: @shopify_custom_collection.handle,
            description: @shopify_custom_collection.body_html
          }
        end

        def product_ids
          @product_ids ||=
            SpreeShopifyImporter::DataFeed
            .where(shopify_object_id: collection_product_ids, shopify_object_type: 'ShopifyAPI::Product')
            .pluck(:spree_object_id)
        end

        def taxonomy
          @taxonomy ||= Spree::Taxonomy.find_or_create_by(name: I18n.t(:shopify_custom_collections))
        end

        private

        def collection_product_ids
          @shopify_custom_collection.products.map(&:id)
        end
      end
    end
  end
end
