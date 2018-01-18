module SpreeShopifyImporter
  module DataFetchers
    class BaseFetcher
      def initialize(params = {})
        @params = params
      end

      def import!
        resources.each do |resource|
          job.perform_later(resource.to_json)
        end
      end

      private

      def resources
        raise NotImplementedError, I18n.t('errors.not_implemented.resources')
      end

      def job
        raise NotImplementedError, I18n.t('errors.not_implemented.job')
      end
    end
  end
end
