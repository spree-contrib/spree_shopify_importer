module SpreeShopifyImporter
  module DataSavers
    module Addresses
      class AddressCreator < AddressBase
        def initialize(shopify_data_feed, spree_user, is_order = false)
          super(shopify_data_feed)
          @spree_user = spree_user
          @is_order = is_order
        end

        def create!
          Spree::Address.transaction do
            create_spree_address
            assigns_spree_address_to_data_feed unless @is_order
          end
          @spree_address
        end

        private

        def create_spree_address
          # Spree Orders should not be users addresses same time.
          @spree_address = (@is_order ? Spree::Address : @spree_user.addresses).new(attributes)

          # Shopify has'n got validation for filed like zipcode, city or province code.
          @spree_address.save(validate: false)
        end
      end
    end
  end
end
