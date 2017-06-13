module ShopifyImport
  module Creators
    class Address
      def initialize(shopify_address, spree_user)
        @shopify_address = shopify_address
        @spree_user = spree_user
      end

      def save!
        Spree::Address.create!(parser.address_attributes)
      end

      private

      def parser
        @parser ||= ShopifyImport::DataParsers::Addresses::BaseData.new(@shopify_address, @spree_user)
      end
    end
  end
end
