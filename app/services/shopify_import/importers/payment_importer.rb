module ShopifyImport
  module Importers
    class PaymentImporter < BaseImporter
      def initialize(transaction, parent_feed, spree_order)
        @transaction = transaction
        @parent_feed = parent_feed
        @spree_order = spree_order
      end

      def import!
        data_feed = process_data_feed

        creator.new(data_feed, @spree_order).create!
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(@transaction, @parent_feed).save!
      end

      def update_data_feed(old_data_feed)
        Shopify::DataFeeds::Update.new(old_data_feed, @transaction, @parent_feed).update!
      end

      def creator
        ShopifyImport::DataSavers::Payments::PaymentCreator
      end

      def shopify_object
        @transaction
      end
    end
  end
end
