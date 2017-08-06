module ShopifyImport
  module Creators
    class PromotionCreator
      def initialize(spree_order, shopify_discount_code)
        @spree_order = spree_order
        @shopify_discount_code = shopify_discount_code
      end

      def save!
        Spree::Promotion.transaction do
          create_promotion
        end
      end

      private

      def create_promotion
        @spree_promotion =
          Spree::Promotion.create_with(expires_at: Time.current).find_or_create_by!(promotion_attributes)
      end

      def expires_at
        @expires_at ||= parser.expires_at
      end

      def promotion_attributes
        @promotion_attributes ||= parser.promotion_attributes
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Promotions::BaseData.new(@shopify_discount_code)
      end
    end
  end
end
