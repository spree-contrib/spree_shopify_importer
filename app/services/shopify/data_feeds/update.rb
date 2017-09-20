module Shopify
  module DataFeeds
    class Update
      attr_reader :shopify_object

      def initialize(shopify_data_feed, shopify_object, parent = nil)
        @shopify_data_feed = shopify_data_feed
        @shopify_object = shopify_object
        @parent = parent
      end

      def update!
        @shopify_data_feed.update!(
          data_feed: shopify_object.to_json,
          parent: @parent
        )
      end
    end
  end
end
