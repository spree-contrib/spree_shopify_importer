module SpreeShopifyImporter
  module RescueApiLimit
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Rescuable
      rescue_from ActiveResource::ClientError, with: :handle_known_exceptions
    end

    def handle_known_exceptions
      retries ||= 1
      yield
    rescue ActiveResource::ClientError => ex
      raise ex if retries >= Spree::Config[:shopify_rescue_limit]

      sleep 2**retries
      retries += 1
      retry
    end
  end
end
