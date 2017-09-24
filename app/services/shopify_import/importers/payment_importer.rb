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

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed, @spree_order).create!
        else
          # Currently order import logic is deleting old data
          spree_object.destroy
          creator.new(data_feed, @spree_order).update!
        end
      end

      private

      def process_data_feed
        (old_data_feed = find_existing_data_feed).blank? ? create_data_feed : update_data_feed(old_data_feed)
      end

      def find_existing_data_feed
        Shopify::DataFeed.find_by(shopify_object_id: @transaction.id, shopify_object_type: @transaction.class.to_s)
      end

      def create_data_feed
        Shopify::DataFeeds::Create.new(@transaction, @parent_feed).save!
      end

      def update_data_feed(old_data_feed)
        Shopify::DataFeeds::Update.new(old_data_feed, @transaction, @parent_feed).update!
      end

      def creator
        ShopifyImport::DataSavers::Payments::PaymentCreator
      end
    end
  end
end
