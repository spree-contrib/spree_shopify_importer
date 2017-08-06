module ShopifyImport
  module Creators
    class AddressCreator < BaseCreator
      def initialize(shopify_data_feed, spree_user)
        @shopify_data_feed = shopify_data_feed
        @spree_user = spree_user
      end

      def save!
        Spree::Address.transaction do
          create_spree_address
          assigns_spree_address_to_data_feed
        end
      end

      private

      # Shopify has'n got validation for filed like zipcode, city or province code.
      def create_spree_address
        @spree_address = Spree::Address.new(address_attributes)
        @spree_address.save(validate: false)
      end

      def assigns_spree_address_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_address)
      end

      def address_attributes
        parser.address_attributes
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Addresses::BaseData.new(shopify_address, @spree_user)
      end

      def shopify_address
        @shopify_address ||= ShopifyAPI::Address.new(data_feed)
      end
    end
  end
end
