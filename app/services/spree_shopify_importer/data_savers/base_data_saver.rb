module SpreeShopifyImporter
  module DataSavers
    class BaseDataSaver
      def self.new(*args, &block)
        SpreeShopifyImporter::Delegator.new(super)
      end

      def initialize(shopify_data_feed)
        @shopify_data_feed = shopify_data_feed
      end

      private

      def data_feed
        @data_feed ||= JSON.parse(@shopify_data_feed.data_feed)
      end
    end
  end
end
