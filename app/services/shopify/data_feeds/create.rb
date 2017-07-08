module Shopify
  module DataFeeds
    class Create
      attr_reader :shopify_object

      def initialize(shopify_object, parent = nil)
        @shopify_object = shopify_object
        @parent = parent
      end

      def save!
        Shopify::DataFeed.create!(
          shopify_object_id: shopify_object.id,
          shopify_object_type: shopify_type,
          data_feed: shopify_object.to_json,
          parent: @parent
        )
      end

      private

      def shopify_type
        shopify_object.class.to_s
      end
    end
  end
end
