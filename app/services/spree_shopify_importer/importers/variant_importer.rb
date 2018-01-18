module SpreeShopifyImporter
  module Importers
    class VariantImporter < BaseImporter
      def initialize(resource, parent_feed, spree_product, shopify_image = nil)
        @resource = resource
        @parent_feed = parent_feed
        @spree_product = spree_product
        @shopify_image = shopify_image
        connect
      end

      def import!
        data_feed = process_data_feed

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed, @spree_product, @shopify_image).create!
        else
          updater.new(data_feed, spree_object, @spree_product, @shopify_image).update!
        end
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(shopify_object, @parent_feed).save!
      end

      def update_data_feed(old_data_feed)
        Shopify::DataFeeds::Update.new(old_data_feed, shopify_object, @parent_feed).update!
      end

      def creator
        SpreeShopifyImporter::DataSavers::Variants::VariantCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Variants::VariantUpdater
      end

      def shopify_object
        ShopifyAPI::Variant.new(JSON.parse(@resource))
      end
    end
  end
end
