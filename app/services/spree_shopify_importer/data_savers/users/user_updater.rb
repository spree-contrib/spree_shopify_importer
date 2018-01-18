module SpreeShopifyImporter
  module DataSavers
    module Users
      class UserUpdater < UserBase
        def initialize(shopify_data_feed, spree_user)
          super(shopify_data_feed)
          @spree_user = spree_user
        end

        def update!
          Spree.user_class.transaction do
            update_spree_user
            generate_api_key
            create_spree_addresses
          end
        end

        private

        def update_spree_user
          @spree_user.update!(merged_attributes)
        end

        def merged_attributes
          attributes.select { |a| Spree.user_class.attribute_method?(a) }
        end
      end
    end
  end
end
