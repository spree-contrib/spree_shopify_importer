module ShopifyImport
  module Importers
    class BaseImporter
      def initialize(params = {})
        @params = params
      end

      def import!
        resources.each do |resource|
          data_feed = Shopify::DataFeeds::Create.new(resource).save!
          creator.new(data_feed).save!
        end
      end

      private

      def resources
        raise NotImplementedError, I18n.t('errors.not_implemented.resources')
      end

      def creator
        raise NotImplementedError, I18n.t('errors.not_implemented.creator')
      end
    end
  end
end
