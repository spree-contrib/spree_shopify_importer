module ShopifyImport
  module DataParsers
    module Users
      class BaseData
        def initialize(shopify_customer)
          @shopify_customer = shopify_customer
        end

        def user_attributes
          {
            created_at: @shopify_customer.created_at,
            email: @shopify_customer.email,
            first_name: @shopify_customer.first_name,
            last_name: @shopify_customer.last_name
          }
        end
      end
    end
  end
end
