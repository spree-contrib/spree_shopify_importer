module ShopifyImport
  module Creators
    class BaseCreator
      def initialize(shopify_data_feed)
        @shopify_data_feed = shopify_data_feed
      end

      def save!
        raise NotImplementedError
      end

      private

      def data_feed
        @data_feed ||= JSON.parse(@shopify_data_feed.data_feed)
      end
    end
  end
end
