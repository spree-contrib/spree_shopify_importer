module SpreeShopifyImporter
  module Importers
    class ImageImporter < BaseImporter
      def initialize(resourece, parent_feed, spree_viewable)
        @resource = resourece
        @parent_feed = parent_feed
        @spree_viewable = spree_viewable
      end

      def import!
        data_feed = process_data_feed

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed, @spree_viewable).create!
        else
          updater.new(data_feed, spree_object, @spree_viewable).update!
        end
      end

      private

      def process_data_feed
        (old_data_feed = find_existing_data_feed).blank? ? create_data_feed : update_data_feed(old_data_feed)
      end

      def create_data_feed
        SpreeShopifyImporter::DataFeeds::Create.new(shopify_object, @parent_feed).save!
      end

      def update_data_feed(old_data_feed)
        SpreeShopifyImporter::DataFeeds::Update.new(old_data_feed, shopify_object, @parent_feed).update!
      end

      def creator
        SpreeShopifyImporter::DataSavers::Images::ImageCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Images::ImageUpdater
      end

      def shopify_object
        ShopifyAPI::Image.new(JSON.parse(@resource))
      end
    end
  end
end
