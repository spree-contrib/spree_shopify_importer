module ShopifyImport
  module Importers
    class BaseImporter
      def initialize(resource = nil)
        @resource = resource
      end

      def import!
        data_feed = create_data_feed
        creator.new(data_feed).save!
      end

      private

      def create_data_feed
        Shopify::DataFeeds::Create.new(shopify_object).save!
      end

      def shopify_object
        shopify_class.new(JSON.parse(@resource))
      end

      def creator
        raise NotImplementedError, I18n.t('errors.not_implemented.creator')
      end

      def shopify_class
        raise NotImplementedError, I18n.t('errors.not_implemented.shopify_class')
      end
    end
  end
end
