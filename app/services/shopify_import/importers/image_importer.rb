module ShopifyImport
  module Importers
    class ImageImporter
      def initialize(resourece, parent_feed, spree_object)
        @resource = resourece
        @parent_feed = parent_feed
        @spree_object = spree_object
      end

      def import!
        shopify_data_feed = create_data_feed
        create_spree_image(shopify_data_feed)
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(shopify_image, @parent_feed).save!
      end

      def create_spree_image(shopify_data_feed)
        ShopifyImport::Creators::ImageCreator.new(shopify_data_feed, @spree_object).save!
      end

      def shopify_image
        ShopifyAPI::Image.new(JSON.parse(@resource))
      end
    end
  end
end
