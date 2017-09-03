module ShopifyImport
  module Importers
    class VariantImporter
      def initialize(resource, parent_feed, spree_product, shopify_image = nil)
        @resource = resource
        @parent_feed = parent_feed
        @spree_product = spree_product
        @shopify_image = shopify_image
      end

      def import!
        shopify_data_feed = create_data_feed
        create_spree_variant(shopify_data_feed)
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(shopify_object, @parent_feed).save!
      end

      def create_spree_variant(shopify_data_feed)
        ShopifyImport::Creators::VariantCreator.new(shopify_data_feed, @spree_product, @shopify_image).save!
      end

      def shopify_object
        ShopifyAPI::Variant.new(JSON.parse(@resource))
      end
    end
  end
end
