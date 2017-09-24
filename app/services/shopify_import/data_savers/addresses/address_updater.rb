module ShopifyImport
  module DataSavers
    module Addresses
      class AddressUpdater < AddressBase
        def initialize(shopify_data_feed, spree_address)
          super(shopify_data_feed)
          @spree_address = spree_address
        end

        def update!
          Spree::Address.transaction do
            update_spree_address
          end

          @spree_address
        end

        private

        def update_spree_address
          @spree_address.assign_attributes(attributes)
          @spree_address.save(validate: false)
        end
      end
    end
  end
end
