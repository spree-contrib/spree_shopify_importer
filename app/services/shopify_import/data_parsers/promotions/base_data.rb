module ShopifyImport
  module DataParsers
    module Promotions
      class BaseData
        def initialize(shopify_discount_code)
          @shopify_discount_code = shopify_discount_code
        end

        def attributes
          @attributes ||= {
            name: code,
            code: code
          }
        end

        def expires_at
          @expires_at ||= Time.current
        end

        private

        def code
          @code ||= @shopify_discount_code.code.try(:downcase)
        end
      end
    end
  end
end
