module ShopifyImport
  module Importers
    class BaseImporter
      def initialize(resource = nil)
        @resource = resource
      end

      def import!
        if (old_data_feed = find_existing_data_feed).blank?
          data_feed = create_data_feed
          creator.new(data_feed).save!
        else
          update_data_feed(old_data_feed)
        end
      end

      private

      def find_existing_data_feed
        Shopify::DataFeed.find_by(shopify_object_id: shopify_object.id, shopify_object_type: shopify_object.class.to_s)
      end

      def create_data_feed
        Shopify::DataFeeds::Create.new(shopify_object).save!
      end

      def update_data_feed(old_data_feed)
        Shopify::DataFeeds::Update.new(old_data_feed, shopify_object).update!
      end

      def shopify_object
        shopify_class.new(JSON.parse(@resource))
      end

      def creator
        raise NotImplementedError, I18n.t('errors.not_implemented.creator')
      end

      def updater
        raise NotImplementedError, I18n.t('errors.not_implemented.updater')
      end

      def shopify_class
        raise NotImplementedError, I18n.t('errors.not_implemented.shopify_class')
      end
    end
  end
end
