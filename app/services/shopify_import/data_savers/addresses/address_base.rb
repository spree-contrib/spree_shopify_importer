module ShopifyImport
  module DataSavers
    module Addresses
      class AddressBase < BaseDataSaver
        delegate :attributes, to: :parser

        private

        def assigns_spree_address_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_address)
        end

        def address_attributes
          parser.address_attributes
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::Addresses::BaseData.new(shopify_address)
        end

        def shopify_address
          @shopify_address ||= ShopifyAPI::Address.new(data_feed)
        end
      end
    end
  end
end
