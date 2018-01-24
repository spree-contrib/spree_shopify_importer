module SpreeShopifyImporter
  module Importers
    class BaseImporter
      def initialize(resource = nil)
        @resource = resource
        connect
      end

      def import!
        data_feed = process_data_feed

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed).create!
        else
          updater.new(data_feed, spree_object).update!
        end
      end

      private

      def process_data_feed
        (old_data_feed = find_existing_data_feed).blank? ? create_data_feed : update_data_feed(old_data_feed)
      end

      def find_existing_data_feed
        SpreeShopifyImporter::DataFeed.find_by(shopify_object_id: shopify_object.id,
                                               shopify_object_type: shopify_object.class.to_s)
      end

      def create_data_feed
        SpreeShopifyImporter::DataFeeds::Create.new(shopify_object).save!
      end

      def update_data_feed(old_data_feed)
        SpreeShopifyImporter::DataFeeds::Update.new(old_data_feed, shopify_object).update!
      end

      def shopify_object
        @shopify_object ||= shopify_class.new(JSON.parse(@resource))
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

      def connect
        client = SpreeShopifyImporter::Connections::Client.instance

        client.get_connection(credentials) if credentials.present? && client.connection.blank?
      end

      def credentials
        Spree::Config[:shopify_current_credentials]
      end
    end
  end
end
