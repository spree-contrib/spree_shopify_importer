module ShopifyImport
  module Creators
    class AddressCreator < BaseCreator
      delegate :attributes, to: :parser

      def initialize(shopify_data_feed, spree_user, is_order = false)
        @shopify_data_feed = shopify_data_feed
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
