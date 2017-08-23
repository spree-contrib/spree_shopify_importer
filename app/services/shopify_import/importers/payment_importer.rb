module ShopifyImport
  module Importers
    class PaymentImporter
      def initialize(transaction, parent_feed, spree_order)
        @transaction = transaction
        @parent_feed = parent_feed
        @spree_order = spree_order
      end

      def import!
        shopify_data_feed = create_data_feed
        create_shopify_payment(shopify_data_feed)
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(@transaction, @parent_feed).save!
      end

      def create_shopify_payment(shopify_data_feed)
        ShopifyImport::Creators::PaymentCreator.new(shopify_data_feed, @spree_order).save!
      end
    end
  end
end
